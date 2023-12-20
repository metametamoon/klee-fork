#ifndef KLEE_PROOFOBLIGATION_H
#define KLEE_PROOFOBLIGATION_H

#include "ExecutionState.h"

#include "klee/ADT/ImmutableList.h"
#include "klee/Expr/Constraints.h"
#include "klee/Expr/Path.h"
#include "klee/Module/KInstruction.h"
#include "klee/Module/KModule.h"
#include "klee/Module/Target.h"
#include "klee/Module/TargetForest.h"
#include "klee/Expr/Lemma.h"

#include <queue>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

namespace klee {
class ProofObligation;

struct ProofObligationIDCompare {
  bool operator()(const ProofObligation *a, const ProofObligation *b) const;
};

struct LemmaCheckPobData {
    ref<Lemma> lemma_to_check;
    KBlock* starting_location;
    ref<Target> reach_block_target;
    std::optional<bool> wasConsecutionContradicted = std::nullopt;
    std::optional<bool> wasInitiationContradicted = std::nullopt;
};


class ProofObligation {
public:
  enum class Kind {
    Normal,
    ConsecutionCheck,
    InitiationCheck
  };

  ProofObligation(ref<Target> _location)
      : id(nextID++), parent(nullptr), root(this), location(_location),
        nullPointerExpr(nullptr) {}

  ~ProofObligation() {
    for (auto pob : children) {
      pob->parent = nullptr;
    }
    if (parent) {
      parent->children.erase(this);
    }
  }

  std::set<ProofObligation *, ProofObligationIDCompare> getSubtree();

  bool atReturn() const { return isa<KReturnBlock>(location->getBlock()); }
  std::uint32_t getID() const { return id; };
  bool isTargeted() const { return isTargeted_; };
  void setTargeted(bool targeted) { isTargeted_ = targeted; }

  static ProofObligation *create(ProofObligation *parent, ExecutionState *state,
                                 PathConstraints &composed,
                                 ref<Expr> nullPointerExpr);

  static void propagateToReturn(ProofObligation *pob, KInstruction *callSite,
                                KBlock *returnBlock);

private:
  ProofObligation *makeChild(ref<Target> target) {
    auto pob = new ProofObligation(target);
    pob->id = nextID++;
    pob->parent = this;
    pob->root = root;
    pob->propagationCount = propagationCount;
    pob->targetForest = targetForest;
    pob->isTargeted_ = isTargeted_;
    pob->kind = kind;
    children.insert(pob);
    return pob;
  }

public:
  std::uint32_t id;
  ProofObligation *parent;
  ProofObligation *root;
  std::set<ProofObligation *, ProofObligationIDCompare> children;
  std::vector<CallStackFrame> stack;
  std::map<ExecutionState *, unsigned, ExecutionStateIDCompare>
      propagationCount;

  unsigned subtreePropagationCount = 0;

  ref<Target> location;
  TargetForest targetForest;
  PathConstraints constraints;
  ImmutableList<Symbolic> symbolics;

  ref<Expr> nullPointerExpr;
  LemmaCheckPobData* lemmaCheckData = nullptr;
  Kind kind = Kind::Normal; // invariant: ConsecutiveCheck, InitiationCheck -> lemmaCheckData != nullptr
private:
  static unsigned nextID;
  bool isTargeted_ = false;
};

using pobs_ty = std::set<ProofObligation *, ProofObligationIDCompare>;

} // namespace klee

#endif
