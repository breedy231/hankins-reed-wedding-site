#!/bin/bash
# Ralph Wiggum Loop - OG Bash Implementation
# Usage: ./scripts/ralph-loop.sh "Your prompt here" [max_iterations]

PROMPT="$1"
MAX_ITERATIONS="${2:-50}"
ITERATION=0

echo "🍩 Starting Ralph Wiggum Loop"
echo "📝 Prompt: $PROMPT"
echo "🔄 Max iterations: $MAX_ITERATIONS"
echo ""

while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    ITERATION=$((ITERATION + 1))
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔄 Iteration $ITERATION of $MAX_ITERATIONS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Run Claude with the prompt
    claude --print "$PROMPT"
    EXIT_CODE=$?
    
    # Check if Claude signaled completion (exit 0)
    if [ $EXIT_CODE -eq 0 ]; then
        echo ""
        echo "✅ Ralph completed successfully after $ITERATION iterations!"
        exit 0
    fi
    
    echo ""
    echo "⏳ Continuing to next iteration..."
    sleep 2
done

echo ""
echo "⚠️  Ralph reached max iterations ($MAX_ITERATIONS) without completing."
exit 1
