# Full PR Review Workflow

Comprehensive PR creation, review, and fix workflow. Maximum of 2 review-fix cycles without additional prompting.

## Workflow Steps

### Phase 1: Create PR
1. Ensure all changes are committed on the current feature branch
2. Push the branch to remote if not already pushed
3. Create a PR with:
   - **Title**: Descriptive name summarizing the changes
   - **Description**: Summary of what was changed, why, and any notable implementation details

### Phase 2: Initial PR Review
1. Run the `/pr-review-toolkit:review-pr` command on the current PR
2. Collect findings into categories:
   - **Critical issues**: Must be fixed
   - **Major issues**: Must be fixed
   - **Minor issues**: Fix if quick/simple, or if no critical/major issues exist
3. **IMPORTANT: Post comment BEFORE fixing** - Post a comment on the PR with:
   - Overall review summary
   - Critical/Major/Minor issues with explanatory descriptions
   - Recommended next steps
   - This documents what was found so fixes can be verified after the fact

### Phase 3: Fix Issues (Cycle 1)
1. **Always fix**: All critical and major issues
2. **Fix minor issues if**:
   - They are quick and simple to fix, OR
   - There are no critical/major issues (then always fix minor)
3. Commit fixes with descriptive message
4. Push to the PR branch

### Phase 4: Second PR Review
1. Re-run `/pr-review-toolkit:review-pr`
2. **Post comment BEFORE fixing** - Post another comment on the PR with updated findings
3. Fix any new issues that arose from the fixes (same rules as Phase 3)

### Phase 5: CI Monitoring
1. Monitor GitHub CI check status
2. If checks fail:
   - Fix the reported issues
   - Stay within the scope of previous PR fixes
   - Do not introduce unrelated changes
3. If checks pass: Proceed to finalization

### Phase 6: Documentation
1. Update any docs related to this feature if needed:
   - `docs/SESSION_SUMMARY.md` - Add to recently completed
   - `docs/FEATURES.md` - Update feature checklist if applicable
   - Other relevant docs

### Phase 7: Final Report
Provide a concise summary including:
1. Summary of changes made
2. Critical/major issues that were fixed (if any)
3. Final PR status
4. **LAST LINE(S) MUST BE**: Link(s) to the PR(s)

## Example Final Output

```
## PR Review Complete

**Changes**: Added GetItems() function to Go backend with frontend button integration.

**Issues Fixed**:
- (Critical) Fixed XSS vulnerability in list rendering
- (Major) Added error handling for API calls

**CI Status**: All checks passing

**PR**: https://github.com/user/repo/pull/123
```

## Notes
- Maximum 2 review-fix cycles without additional user prompting
- Always include PR link(s) as the final line(s) of the response
- For multiple PRs (parallel agents), list all PR links at the end
