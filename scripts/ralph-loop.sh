#!/bin/bash
# Ralph Wiggum Loop v2 - With Progress Tracking & Logging
# Usage: ./scripts/ralph-loop-v2.sh <phase> [max_iterations]
# Example: ./scripts/ralph-loop-v2.sh 2 30

set -e

PHASE="${1:-2}"
MAX_ITERATIONS="${2:-30}"
ITERATION=0
LOG_FILE="ralph-phase${PHASE}-$(date +%Y%m%d-%H%M%S).log"
PROMPT_FILE="prompts/PROMPT-PHASE${PHASE}.md"
COMPLETION_MARKER="PHASE${PHASE}_DONE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Progress check function
check_progress() {
    log "\n${BLUE}📊 Progress Check:${NC}"
    
    # Count components
    COMPONENT_COUNT=$(find src/components -name "*.astro" 2>/dev/null | wc -l | tr -d ' ')
    log "   Components: ${COMPONENT_COUNT} .astro files"
    
    # Count pages
    PAGE_COUNT=$(find src/pages -name "*.astro" 2>/dev/null | wc -l | tr -d ' ')
    log "   Pages: ${PAGE_COUNT} .astro files"
    
    # Check build status
    if npm run build --silent 2>/dev/null; then
        log "   ${GREEN}✅ Build: PASSING${NC}"
        BUILD_STATUS="passing"
    else
        log "   ${RED}❌ Build: FAILING${NC}"
        BUILD_STATUS="failing"
    fi
    
    # Check for recent git changes
    UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    log "   Uncommitted changes: ${UNCOMMITTED} files"
    
    # Last commit
    LAST_COMMIT=$(git log --oneline -1 2>/dev/null || echo "No commits")
    log "   Last commit: ${LAST_COMMIT}"
}

# Check if prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo -e "${RED}❌ Error: $PROMPT_FILE not found${NC}"
    exit 1
fi

# Header
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "${GREEN}🍩 Ralph Wiggum Loop v2${NC}"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "📝 Phase: ${PHASE}"
log "📄 Prompt file: ${PROMPT_FILE}"
log "🔄 Max iterations: ${MAX_ITERATIONS}"
log "📋 Log file: ${LOG_FILE}"
log "🎯 Completion marker: ${COMPLETION_MARKER}"
log "⏰ Started: $(date)"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Initial progress check
check_progress

# The prompt we send to Claude
FULL_PROMPT="You are in a Ralph Wiggum autonomous loop (iteration will be shown).

YOUR TASK: Execute the instructions in ${PROMPT_FILE}

IMPORTANT RULES:
1. DO NOT ask for permission - use --dangerously-skip-permissions if needed or assume you have access
2. Work autonomously - make decisions and proceed
3. After completing significant work, run: npm run build
4. If build fails, fix the errors before proceeding
5. Commit working code frequently with descriptive messages
6. When ALL completion criteria in the prompt are met, output exactly: ${COMPLETION_MARKER}
7. If you cannot proceed due to a blocker, describe the blocker clearly and output: BLOCKED

Read ${PROMPT_FILE} now and continue where you left off. Check git log and file structure to understand current state."

log "\n"

while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    ITERATION=$((ITERATION + 1))
    
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "${YELLOW}🔄 Iteration ${ITERATION} of ${MAX_ITERATIONS}${NC} - $(date +%H:%M:%S)"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Run Claude and capture output
    TEMP_OUTPUT=$(mktemp)
    
    # Run claude with the prompt, tee to both file and stdout
    claude --dangerously-skip-permissions --print "$FULL_PROMPT

--- ITERATION $ITERATION of $MAX_ITERATIONS ---" 2>&1 | tee "$TEMP_OUTPUT"
    
    CLAUDE_EXIT=$?
    OUTPUT=$(cat "$TEMP_OUTPUT")
    rm "$TEMP_OUTPUT"
    
    # Log the output
    echo "$OUTPUT" >> "$LOG_FILE"
    
    # Check for completion marker in output
    if echo "$OUTPUT" | grep -q "$COMPLETION_MARKER"; then
        log "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        log "${GREEN}✅ PHASE ${PHASE} COMPLETED after ${ITERATION} iterations!${NC}"
        log "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        check_progress
        log "\n⏰ Finished: $(date)"
        log "📋 Full log: ${LOG_FILE}"
        exit 0
    fi
    
    # Check for blocked marker
    if echo "$OUTPUT" | grep -q "BLOCKED"; then
        log "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        log "${RED}🚧 BLOCKED - Ralph needs human intervention${NC}"
        log "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        check_progress
        log "\n📋 Check log for details: ${LOG_FILE}"
        exit 1
    fi
    
    # Check for rate limit
    if echo "$OUTPUT" | grep -qi "rate.limit\|too.many.requests\|429"; then
        log "\n${YELLOW}⏳ Rate limited - waiting 60 seconds...${NC}"
        sleep 60
    fi
    
    # Check for permission issues (don't count as success)
    if echo "$OUTPUT" | grep -qi "permission\|Please grant\|don't have access"; then
        log "\n${YELLOW}⚠️  Permission issue detected - will retry${NC}"
    fi
    
    # Progress check every 5 iterations
    if [ $((ITERATION % 5)) -eq 0 ]; then
        check_progress
    fi
    
    log "\n${BLUE}⏳ Continuing to iteration $((ITERATION + 1))...${NC}\n"
    sleep 3
done

log "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
log "${YELLOW}⚠️  Max iterations (${MAX_ITERATIONS}) reached without completion${NC}"
log "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
check_progress
log "\n📋 Full log: ${LOG_FILE}"
exit 1
