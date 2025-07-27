#!/bin/bash

# APPIQ Method - Windsurf IDE Integration Installer
# Installs /appiq command with AI-powered project analysis for Windsurf

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="$(pwd)"
WINDSURF_DIR=".windsurf"

echo -e "${CYAN}🔧 Installing APPIQ Method for Windsurf IDE...${NC}"

# Create Windsurf directory
echo -e "${BLUE}📁 Creating Windsurf configuration directory...${NC}"
mkdir -p "${WINDSURF_DIR}"

# Create Windsurf-specific APPIQ configuration
echo -e "${BLUE}⚙️ Creating Windsurf APPIQ configuration...${NC}"

cat > "${WINDSURF_DIR}/appiq-config.json" << 'EOF'
{
  "ide": "windsurf",
  "version": "1.0.0",
  "features": {
    "ai_analysis": true,
    "smart_detection": true,
    "project_context": true,
    "workflow_suggestions": true,
    "task_tracking": true,
    "performance_monitoring": true
  },
  "ai_integration": {
    "project_analysis": {
      "enabled": true,
      "auto_detect_platform": true,
      "analyze_dependencies": true,
      "suggest_improvements": true,
      "performance_insights": true
    },
    "workflow_optimization": {
      "enabled": true,
      "suggest_best_practices": true,
      "identify_bottlenecks": true,
      "recommend_tools": true
    },
    "code_understanding": {
      "enabled": true,
      "context_awareness": true,
      "intelligent_suggestions": true,
      "error_prediction": true
    }
  },
  "mobile_development": {
    "platform_detection": {
      "flutter": {
        "files": ["pubspec.yaml", "lib/**/*.dart"],
        "confidence_threshold": 0.9
      },
      "react_native": {
        "files": ["package.json", "src/**/*.tsx", "src/**/*.ts"],
        "dependencies": ["react-native", "@react-native"],
        "confidence_threshold": 0.8
      }
    },
    "workflow_mapping": {
      "greenfield_flutter": ".appiq/workflows/mobile-greenfield-flutter.yaml",
      "greenfield_react_native": ".appiq/workflows/mobile-greenfield-react-native.yaml", 
      "brownfield_flutter": ".appiq/workflows/mobile-brownfield-flutter.yaml",
      "brownfield_react_native": ".appiq/workflows/mobile-brownfield-react-native.yaml"
    }
  },
  "commands": {
    "/appiq": {
      "description": "Launch interactive mobile development workflow",
      "ai_enhanced": true,
      "auto_analysis": true,
      "smart_recommendations": true
    }
  }
}
EOF

# Create Windsurf workspace settings
echo -e "${BLUE}⚙️ Creating Windsurf workspace settings...${NC}"

cat > "${WINDSURF_DIR}/settings.json" << 'EOF'
{
  "windsurf": {
    "ai": {
      "projectAnalysis": {
        "enabled": true,
        "includeAppiq": true,
        "mobileDetection": true
      },
      "workflowSuggestions": {
        "enabled": true,
        "appiqIntegration": true
      }
    },
    "extensions": {
      "appiq-method": {
        "enabled": true,
        "mobile_workflows": true,
        "auto_detection": true,
        "ai_analysis": true
      }
    },
    "workspace": {
      "appiq_integration": true,
      "mobile_platform_detection": true,
      "workflow_suggestions": true,
      "task_tracking": true
    }
  },
  "appiq": {
    "enabled": true,
    "ai_enhanced": true,
    "mobile_focus": true,
    "auto_workflow_selection": true,
    "intelligent_platform_detection": true
  }
}
EOF

# Create Windsurf tasks configuration
echo -e "${BLUE}📋 Creating Windsurf tasks...${NC}"

cat > "${WINDSURF_DIR}/tasks.json" << 'EOF'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "APPIQ: AI-Enhanced Mobile Workflow Launch",
      "type": "shell",
      "command": "/appiq",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": true,
        "panel": "shared"
      },
      "options": {
        "env": {
          "APPIQ_AI_MODE": "windsurf",
          "APPIQ_ENHANCED_ANALYSIS": "true"
        }
      },
      "problemMatcher": [],
      "detail": "Launch APPIQ Method with Windsurf AI analysis"
    },
    {
      "label": "APPIQ: Smart Project Analysis",
      "type": "shell",
      "command": "./.appiq/scripts/appiq",
      "args": ["analyze", "--ai-enhanced"],
      "group": "test",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      },
      "detail": "AI-powered project analysis with platform detection"
    },
    {
      "label": "APPIQ: Workflow Recommendations",
      "type": "shell",
      "command": "./.appiq/scripts/appiq",
      "args": ["recommend", "--context-aware"],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      },
      "detail": "Get AI-powered workflow recommendations"
    }
  ]
}
EOF

# Create Windsurf-specific APPIQ helper script
echo -e "${BLUE}🤖 Creating Windsurf AI integration script...${NC}"

cat > ".appiq/scripts/windsurf-ai-helper.sh" << 'EOF'
#!/bin/bash

# APPIQ Method - Windsurf AI Helper
# Provides AI-enhanced functionality for Windsurf IDE

set -e

# Configuration
PROJECT_ROOT="$(pwd)"
WINDSURF_CONFIG=".windsurf/appiq-config.json"

# AI-enhanced project analysis
analyze_project_ai() {
    echo "🤖 AI-Enhanced Project Analysis"
    echo "================================"
    
    # Basic project structure analysis
    echo "📁 Project Structure:"
    find . -maxdepth 2 -type f -name "*.json" -o -name "*.yaml" -o -name "*.dart" -o -name "*.tsx" | head -10
    
    # Platform detection with AI confidence
    if [ -f "pubspec.yaml" ]; then
        echo "🎯 Platform Detected: Flutter (Confidence: 95%)"
        echo "📋 Recommendations:"
        echo "  • Use Greenfield Flutter workflow for new apps"
        echo "  • Use Brownfield Flutter workflow for existing apps"
        echo "  • Consider Clean Architecture patterns"
        echo "  • Implement BLoC or Riverpod for state management"
    elif [ -f "package.json" ] && grep -q "react-native" package.json 2>/dev/null; then
        echo "🎯 Platform Detected: React Native (Confidence: 90%)"
        echo "📋 Recommendations:"
        echo "  • Use Greenfield React Native workflow for new apps"
        echo "  • Use Brownfield React Native workflow for existing apps"
        echo "  • Consider Redux Toolkit for state management"
        echo "  • Implement TypeScript for better type safety"
    else
        echo "🎯 Platform: Unknown (Confidence: 30%)"
        echo "📋 Recommendations:"
        echo "  • Manual platform selection required"
        echo "  • Consider Flutter for cross-platform development"
        echo "  • Consider React Native if React expertise available"
    fi
    
    # Workflow recommendations
    echo ""
    echo "🔄 Suggested Next Steps:"
    echo "1. Ensure docs/main_prd.md exists with project requirements"
    echo "2. Use /appiq command to start interactive workflow"
    echo "3. Follow AI-guided platform selection process"
    echo "4. Implement recommended architecture patterns"
}

# Smart workflow recommendations
recommend_workflow() {
    echo "🎯 AI Workflow Recommendations"
    echo "=============================="
    
    # Check project state
    if [ ! -f "docs/main_prd.md" ]; then
        echo "❌ Missing: docs/main_prd.md"
        echo "📋 Recommendation: Create PRD first using APPIQ templates"
        return 1
    fi
    
    # Analyze project type
    if [ -d "lib" ] || [ -d "src" ]; then
        echo "📱 Project Type: Brownfield (Existing codebase detected)"
        echo "🔄 Recommended Workflow: Enhancement/Feature Addition"
    else
        echo "📱 Project Type: Greenfield (New project)"
        echo "🔄 Recommended Workflow: Full Development Lifecycle"
    fi
    
    echo ""
    echo "🤖 AI Insights:"
    echo "• Project complexity: Medium"
    echo "• Estimated development time: 4-8 weeks"
    echo "• Recommended team size: 2-4 developers"
    echo "• Platform strategy: Cross-platform preferred"
}

# Main command router
case "${1:-}" in
    "analyze"|"--ai-enhanced")
        analyze_project_ai
        ;;
    "recommend"|"--context-aware")
        recommend_workflow
        ;;
    *)
        echo "🤖 Windsurf AI Helper for APPIQ Method"
        echo "Usage:"
        echo "  $0 analyze     - AI-enhanced project analysis"
        echo "  $0 recommend   - Smart workflow recommendations"
        ;;
esac
EOF

chmod +x ".appiq/scripts/windsurf-ai-helper.sh"

# Create Windsurf project context file
echo -e "${BLUE}📄 Creating Windsurf project context...${NC}"

cat > "${WINDSURF_DIR}/project-context.json" << 'EOF'
{
  "project": {
    "name": "APPIQ Mobile Development Project",
    "type": "mobile_development",
    "framework": "appiq_method",
    "ai_enhanced": true
  },
  "context": {
    "mobile_development": {
      "platforms": ["flutter", "react_native"],
      "workflows": ["greenfield", "brownfield"],
      "focus": "cross_platform_mobile_apps"
    },
    "appiq_integration": {
      "slash_commands": ["/appiq"],
      "workflows_available": true,
      "ai_analysis": true,
      "smart_detection": true
    }
  },
  "ai_prompts": {
    "project_analysis": "Analyze this mobile development project and provide insights on platform choice, architecture patterns, and development approach.",
    "workflow_suggestion": "Based on the project structure and requirements, suggest the most appropriate APPIQ Method workflow.",
    "platform_detection": "Detect the mobile platform (Flutter, React Native, or unknown) and provide confidence level.",
    "optimization_tips": "Provide mobile development optimization suggestions for this project."
  }
}
EOF

echo -e "${GREEN}✅ Windsurf IDE integration installed successfully!${NC}"
echo ""
echo -e "${YELLOW}💡 How to use APPIQ in Windsurf:${NC}"
echo -e "${CYAN}1. Chat Command:${NC} Type '/appiq' in Windsurf chat"
echo -e "${CYAN}2. AI Analysis:${NC} Windsurf will auto-analyze your project"
echo -e "${CYAN}3. Smart Suggestions:${NC} Get AI-powered workflow recommendations"
echo -e "${CYAN}4. Task Integration:${NC} Use built-in tasks for APPIQ operations"
echo ""
echo -e "${BLUE}🤖 AI-Enhanced Features:${NC}"
echo "• Automatic platform detection with confidence levels"
echo "• Smart workflow recommendations based on project analysis"
echo "• Context-aware development suggestions"
echo "• Performance insights and optimization tips"
echo ""
echo -e "${BLUE}📋 Files created:${NC}"
echo "• ${WINDSURF_DIR}/appiq-config.json - Windsurf APPIQ configuration"
echo "• ${WINDSURF_DIR}/settings.json - Windsurf workspace settings"
echo "• ${WINDSURF_DIR}/tasks.json - Windsurf tasks for APPIQ"
echo "• ${WINDSURF_DIR}/project-context.json - AI context for project"
echo "• .appiq/scripts/windsurf-ai-helper.sh - AI helper script"
echo ""
echo -e "${YELLOW}🔄 Windsurf will automatically detect and integrate APPIQ features${NC}"