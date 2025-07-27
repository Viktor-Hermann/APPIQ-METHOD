#!/bin/bash

# APPIQ Method - Single File Installer
# Version: 1.0.0
# Auto-generated deployment package

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="$(pwd)"
APPIQ_DIR=".appiq"
DOCS_DIR="docs"

# Banner
show_banner() {
    echo -e "${CYAN}"
    echo "â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—"
    echo "â•‘                    ðŸš€ APPIQ METHOD INSTALLER                     â•‘"
    echo "â•‘                                                                  â•‘"
    echo "â•‘              Mobile Development Workflow Setup                   â•‘"
    echo "â•‘                        Version 1.0.0                            â•‘"
    echo "â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•"
    echo -e "${NC}"
}

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${PURPLE}[STEP]${NC} $1"; }

# Check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
    # Check if we're in a project directory
    if [ ! -f "package.json" ] && [ ! -f "pubspec.yaml" ] && [ ! -f "README.md" ]; then
        log_warning "This doesn't look like a project directory. Continue anyway? (y/n)"
        read -r response
        if [ "$response" != "y" ] && [ "$response" != "Y" ]; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Initialize git if needed
    if [ ! -d ".git" ]; then
        log_warning "Not a git repository. Initialize git? (y/n)"
        read -r response
        if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
            git init
            log_success "Git repository initialized"
        fi
    fi
}

# Create directory structure
create_directories() {
    log_step "Creating APPIQ directory structure..."
    
    mkdir -p "${APPIQ_DIR}"/{workflows,agents,templates,config,scripts}
    mkdir -p "${DOCS_DIR}"
    
    log_success "Directory structure created"
}

# Extract embedded files
extract_embedded_files() {
    log_step "Extracting APPIQ Method files..."
    
    # Extract files from the end of this script
    ARCHIVE_LINE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0")
    tail -n +${ARCHIVE_LINE} "$0" | tar xzf - -C "${APPIQ_DIR}/"
    
    log_success "APPIQ Method files extracted"
}

# Create project configuration
create_project_config() {
    log_step "Creating project configuration..."
    
    # Detect project type
    local project_type="unknown"
    if [ -f "pubspec.yaml" ]; then
        project_type="flutter"
    elif [ -f "package.json" ] && grep -q "react-native" package.json 2>/dev/null; then
        project_type="react-native"
    elif [ -f "package.json" ]; then
        project_type="web"
    fi
    
    cat > "${APPIQ_DIR}/config/project.json" << EOF
{
  "project_name": "$(basename "${PROJECT_ROOT}")",
  "project_type": "${project_type}",
  "appiq_version": "1.0.0",
  "installation_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "mobile_platform": null,
  "workflow_preference": null,
  "auto_detect": true,
  "required_files": ["docs/main_prd.md"],
  "output_directory": "docs/"
}
EOF
    
    log_success "Project configuration created"
}

# Create main PRD if not exists
create_prd_template() {
    log_step "Setting up PRD template..."
    
    if [ ! -f "${DOCS_DIR}/main_prd.md" ]; then
        cat > "${DOCS_DIR}/main_prd.md" << 'EOF'
# Main Product Requirements Document

## Project Overview
**Project Name:** [Your Mobile App Name]
**Type:** Mobile Application
**Platform:** [ ] iOS [ ] Android [ ] Cross-platform

## Core Features
### Epic 1: Core Functionality
- [ ] User authentication
- [ ] Core feature implementation
- [ ] User interface

### Epic 2: Advanced Features
- [ ] Advanced functionality
- [ ] Integrations
- [ ] Analytics

## Technical Requirements
- **Framework:** [Flutter/React Native]
- **Performance:** App launch < 3 seconds
- **Security:** OWASP Mobile Top 10 compliance
- **Platform:** [iOS/Android/Both]

## User Stories
- As a user, I want to [functionality]
- As a user, I want to [feature]
- As a user, I want to [capability]

## Success Criteria
- [ ] App store approval
- [ ] Performance targets met
- [ ] User satisfaction > 4.0 stars

---
*Customize this PRD with your specific requirements*
EOF
        
        log_success "PRD template created at ${DOCS_DIR}/main_prd.md"
        log_warning "Please customize the PRD with your project requirements"
    else
        log_info "main_prd.md already exists"
    fi
}

# Create helper script
create_helper_script() {
    log_step "Creating helper scripts..."
    
    cat > "${APPIQ_DIR}/scripts/appiq" << 'EOF'
#!/bin/bash

# APPIQ Method Helper Script

case "$1" in
    "status")
        echo "ðŸ“Š APPIQ Project Status"
        echo "Project: $(basename "$(pwd)")"
        if [ -f "docs/main_prd.md" ]; then
            echo "âœ… PRD: docs/main_prd.md exists"
        else
            echo "âŒ PRD: docs/main_prd.md missing"
        fi
        ;;
    "validate")
        echo "ðŸ” Validating APPIQ setup..."
        errors=0
        
        if [ ! -f "docs/main_prd.md" ]; then
            echo "âŒ Missing: docs/main_prd.md"
            ((errors++))
        else
            echo "âœ… Found: docs/main_prd.md"
        fi
        
        if [ ! -d ".appiq" ]; then
            echo "âŒ Missing: .appiq directory"
            ((errors++))
        else
            echo "âœ… Found: .appiq directory"
        fi
        
        if [ $errors -eq 0 ]; then
            echo "âœ… All validations passed!"
        else
            echo "âŒ Found $errors issues"
        fi
        ;;
    *)
        echo "ðŸš€ APPIQ Method Helper"
        echo "Commands:"
        echo "  status    - Show project status"
        echo "  validate  - Validate setup"
        echo ""
        echo "To start development:"
        echo "  Use /appiq command in your IDE chat"
        ;;
esac
EOF
    
    chmod +x "${APPIQ_DIR}/scripts/appiq"
    log_success "Helper script created"
}

# Update README
update_readme() {
    log_step "Updating README..."
    
    local readme_file="README.md"
    if [ ! -f "${readme_file}" ]; then
        touch "${readme_file}"
    fi
    
    if ! grep -q "APPIQ Method" "${readme_file}" 2>/dev/null; then
        cat >> "${readme_file}" << 'EOF'

## ðŸš€ APPIQ Method - Mobile Development

This project uses APPIQ Method for automated mobile development workflows.

### Quick Start
1. Customize `docs/main_prd.md` with your requirements
2. Use `/appiq` command in your IDE (Claude, Cursor, Windsurf)
3. Follow the interactive workflow

### Commands
- `./.appiq/scripts/appiq status` - Check project status
- `./.appiq/scripts/appiq validate` - Validate setup

### Workflows
- **Greenfield**: New Flutter/React Native app development
- **Brownfield**: Existing app enhancement
EOF
        log_success "README updated"
    else
        log_info "README already contains APPIQ section"
    fi
}

# Show completion message
show_completion() {
    echo -e "${GREEN}"
    echo "â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—"
    echo "â•‘                    âœ… INSTALLATION COMPLETE!                     â•‘"
    echo "â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•"
    echo -e "${NC}"
    
    echo -e "${CYAN}ðŸŽ‰ APPIQ Method successfully installed!${NC}"
    echo ""
    echo -e "${YELLOW}ðŸ“‹ Next Steps:${NC}"
    echo "1. Edit: ${BLUE}docs/main_prd.md${NC} (customize for your project)"
    echo "2. Open your IDE (Claude, Cursor, Windsurf)"
    echo "3. Use command: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}ðŸ’¡ IDE Support:${NC}"
    echo "â€¢ Claude Code: ${GREEN}/appiq${NC}"
    echo "â€¢ Cursor: ${GREEN}/appiq${NC} or ${GREEN}Ctrl+Alt+A${NC}"
    echo "â€¢ Windsurf: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}ðŸ”§ Helper Commands:${NC}"
    echo "â€¢ ${BLUE}./.appiq/scripts/appiq status${NC}"
    echo "â€¢ ${BLUE}./.appiq/scripts/appiq validate${NC}"
}

# Main installation function
main() {
    show_banner
    log_info "Installing APPIQ Method in: $(pwd)"
    
    check_prerequisites
    create_directories
    extract_embedded_files
    create_project_config
    create_prd_template
    create_helper_script
    update_readme
    
    show_completion
}

# Run installation
main "$@"

# Exit before archive
exit 0

__ARCHIVE_BELOW__
‹ ì[†h ì½_oI–/6÷†aúùú9·{§UÔVÿK3ìVÏR¥æ´(qHJÝ³ƒ;Y•ÅÊQUeuf)ŽZÀÅö‹a?øcqá…á‡ûÅð£_ýQöì›_}þEÄ‰ÈÈ"ÕÓÒîífag[ÌŒˆŒ8qâÄ‰çüN÷4=Ï&³êïñ·ººzk+¡ÿÞãÿ®®oòùßÉÚÖêæÚæÖÖý­Ídumcs}íÉêûì”ùÍ«YZBW.Òé´êä³¦rPl0XÐ%±ÿýÏå÷_ü7ÿå/þí/~qö’çÇÉ×‰üðÙ/þ+øß:üï;øþý¿ß¬É““#ù'Öø_àÿuPäß¸çÿ®WŒ»@üQÖ–ÅE6I'½ìÿæßþâþÝÒÿ[üÿÇÿú#òö×ô;L_‘¥ý¬\yràÚõ¿¶¬ÿ­µÍû¿H^¿Î„¿ŸùúßXMÆ³|œ=X»¿µqocëWë«Ýû›8?ë÷–¶î'O÷îí~±ÿr¯û:ÍÊnl¹>ØùÝþÎxøâËËñÊÆw·¹´ùëä*=ýý¢Jj/ýKÓáçúãU¿ò^¿qÝúÇõìÿë[°þ·Þk¯ä÷3_ÿ2ÿÝÓqq–²ÎtÜ÷äo =îmn¾‹þ·uïþ½[ýïƒünõ¿ŸõOÖ¿Sßƒ¸vý×ô¿û›ë›·úß‡øEõ¿Í­µ­Í­[ýï'ÿ“õÿwÿëÖÿú½µšþ·µyïÖþóA~Ng©,FÙvr@,–EÞ›%éx£\šfeULÒíä8›äEÙT¬ŸU½2ŸÎòb²|ÞYJ’½×Pu–0g%S)?æòI5Ízy:Êÿ”OÎ“|’<Íg3xžNúÉQ–BÉgé,¿È”y/Å†«.4»[fé,«(Ó2f“
K=ª’YšŠ2ë'è§|ª'ýì"Ó1pzêAØèð»ÓQ:ƒ²ãõf÷ ý2ûnž—®ÚÉ¼‚>e8’<‘•LSìåÞ`GeÕò²šÁWªü|Í'½$ô¨2Í&}¨™gÕ64>ËÆøMþ#I:¦…iÙïÌàU÷*äÕ€)}W"…:¢P´€éÐj^f4>¯Ì,­^ÙNôˆ¤~ÑƒÕï7 ©Ñ©]UyåJYšÞ@Y.ÑOg©ùÆÙ8íw^¹ªfxjr:çs˜™Q>Éä½aÖ{5Ê«Y^ãŽ}‡E—pÏæÓÓ|RÍJà3ä–íä{¨µ|1ÌØ¶ìËèaú}€yL‘#5ôäQÑ›ó¿ZÈjË	´l˜&®šxÏ°®æAäbø¿ƒ+f¬Y^e°z£yŸùþo­›Ü½Ë]î<&îÒ½¹{—¨äx”€Z†*¦CÌµ,æå$»ªˆSó	Ð:eº˜Ê»²’Y1ï¹È íeÀÜçY…Óé±yòâkËþ¦‰ÃQ:¡÷óÁ +¡s	ˆ,›$Uþ§Œ?]àÒ™¥æÓðë8ºCaÛ.áÆ¶ëf–®ê«4nãö5‹Öú•Ã™íLúe‘÷Í"uŒFrd”£>R£ÊŽj³ê}ƒÚsð6hH@?è'¶•|’œd½á¹cñÜMU¥3ÃqZ¾ª6²;&\%Å`€_Oó	M*HÒÙõ]R]ACe1ÉÿDT­‘åŒæš=–BBÌ
ØºÂr»ÌÜÄ>fºÃ ŸIE7$–ÍVøÀš©`E¼<ºÃ`sý¨3ÓaŠE`s m5ÏgéZ_-Ú))?Ÿöñã½«ÞÈrÆ(ƒæa¹²óÜLÖÎ,Vú
L>´OË®“|{w˜¦ß"™‡Åe’ÖŠéÕpx@L Œƒ•EŒ‚8þ¶FËº =¤8IÓ?ù"+îðs=´€Å±v p±âA:u+cVØW–©Ét2Ý|ÁTË^ƒ$Å-ú—\æ³¡©ÝóVçªK7HÓd•É¥¥ý;ãä
Ø¨Qè†›?Qÿlê‹%1²ÈÍÔòÐ$r.u«²IZºm íÄ”+ØÖN,õ–=ï_ÁNÿ±#
PðØ—¼5¯;Ç†|¹·´t÷îÛ{NÙ8i»+¬“œ ”]C‰siPà	íÎ-©Iz‘ŸóÂ6R˜¿cº!+?Ã­ä‹€²7ÌgYÛ²0çÀL4ý¼ê
""¾Ã¶'Â¾ÂÞçã³Î {Þ‡íðP|DdE:öX,)©ÿÄIà}Ì9“GŠBû‹9¬8zE{’.¯$vÇ
ö˜˜¢ˆÕ@["Qì ê@9áü@1Á¾ç®kþ"„ÛÍÁ¢½Ú¬ê]As2•›!å%Ás¸Úp²²qbz^Áºñ¾ïŠÇ/ÎÇ¤yëm	F“Í.‹òU’`ÄÈQWážGw«×ÈyäßEAŠ;:/?aùÜ¡°ÜÇÀÕ%ýmjàgîÞÝ™ƒ»¹(CŸ$Ï'gEZöaÍÓî·À“ŒŠsŠìôòa^Œ³Y	ó–zÑKÍ¤…môËâ’EÞN¯WÌa2YÊÈFwÜbÆ¸D}|æXâ`<·(vÔ¢Þž¤gµeÆÃ˜¥½WQîâ-?›&@ñWØÁj>åŒ«e¸òX¸À:+.pb,çî=Â}ýÀîÊÒ3ƒ»~'yZ ‚ŒZc!¢,t÷¼òˆâPføâpI6YhD** gq8j+åù¶KËÊ5oâa)Û7f¦ó2Ç¶œõpÇçz­D ú®jo¾ÈÒÑløe>[ùØþÛP÷Ög¢å3!‹Š°?OŠâ¼á‹F¸ ûÞ|}ó…ærüD:AÂØÉÒõ.óþy63¤Úé_`gúfÕx„z”]ä  ”,”îí¦c&ÄÓaýåge
ì‘ö@Uçï=9d-wTÈƒ›ã·‡ój˜LŠ™ZÓ2½3Ü0±"ðÈmSóÊ«@Î¥0#ÔÀ‚È/P^˜qH‡auH”¡)¬çszþDS±’Îûyß™ç‘Õ0¥y/¦@Ð¥ó"Ì{Ý?Üs=Õ`GÎ§(ˆ6$ºà,Eëoù<„jjLKß~ûí’Ì½Gzd¯g¶•í¥úóü§?ÿ{ø¿DfçÉa³-Ãû¿mÔ•µxœZq]õ²	tº€##êsÔ†@Ív‚Ry¹VûeîçsÙpðtØ3'SúÏRšvÆrÎbsˆôôå»kšT®"JCãžO²6lZL³ØÖÖµvÜŒŽ€ÈvaowˆWsšÙ«ptÅ¬v°§‡žxŸCå€Î·gÙÄ,lBÞ¡Ô4‹paaóåÝ²¨ªŽQù¸‡ÕŒöÌI–õ+âb'8¼ÆOv| £3Žæ-WøØÛW5{5©5ZãÆ:Ja·’²°|¶zÛ¯—=æƒ8lM£TÙX]×‹kU
­­®<LpÃý¥6¡FùÈAþõfÛÉŒ4B¨`÷jIreåÌðÀÂaâÃHËAÄnÒ"»Ù,Ù€£éa"å}U_HVjî'#TÕ]øh}íoêud+ã…•÷áÐ¿ ã2õ¡Î¤KKÊ£ÐT¡Ö]\ëÁ"Jª-7üPdê¢V,K ˜‘ë“bÑ0-ÇotÝÂ4z ¢¼³É)¬ñlƒ[ÆW´&ÇW°¬Æ±}nJÊX¶Ìú‰wù‹÷6ŸÔ¤Ž¡$mdÕìjÄI»€—ÄØÀHûé””|»7cç@m›eJ»"ãÄÄi§OFÅ©QX¬Ö7£cÑyßµÁ‚C´ÂYz¤O‘6Ü®Éí„ºZqR{×a"ÚëQÓ-v)!ª†ÆpeÞIÈL.ïT_ý¢ƒOˆæœ(áÁ˜¡Û÷0Åƒü|®”_½fMõJÆb«…ÓÔÐ»˜

îÉÄlNÂá6¯4[¤Ýñ|Œ
kŸ º_æ1üv²;BR"¦órZTÌÄéhN7&ð$—ÓÞÝ»'i‰+u•
›8ˆ}å¶†-Uð¤C%æñœ6aô¨Ï©&èû_î‹y+KñOÜ+s:Uó÷9QD©ŠÊ’Œá¬àI`{#Ÿæ‘1±{rPDˆ•{þ[”BFƒÛ	á¹± u.ÖéÛ| h'Ó^vV tQ½1tcešVHÇ~ýL¹àÄ™´`?ÏJ4/ÌÚ	™&öI»æ Yfr‚ÃÞÇƒ
¶Û%ÐèlL#y,‡S<Á¹#+ÒmG²cT@V¦¨ØAšÛCFÍšÈÐ˜öJóQ£)KJÙå±R>8brn|¾”S¤ZZ(¸GÅ¼Ê«šUÞUA dµM«Ã•ú´¢»fÏTf+ú8yVL:×°Š–I xñXÓ—o,2¶pÐàƒ u©D}n'”)– qíÈ³ÛŒ@,Z!lpâ¡Œ©†“^y55ÂÊë?t¯2µA>ÌŠ^1ªô<Ù)’Rü&iïJˆa‰<:<j'»»‡;Ë4ù¾ŠNtÉ’\„øÔk49a«ü|ˆ8£šñ»ó2îÐx²ª ‡¾å…*^Tµyç;7ëu#ClâQk¬“çü˜ìt—>lq”«!ØuÎçHBÿ(Ì…jWP	ú‘ºeÁ‘V³Ç# Ç¸f•V¹kžÐôõ´ÞUc‰¥W×w94xúÛ©aU¶x\ßkýiT'
øÃë¹ÕI~aïr‘ôÈ8Ó1Õ®Ù/xÚö¦ðÉæÍ›Ä"ÛQé®2ð±«m#éŸ’¤ß÷G[;ìJ£½t"{]jð0o\œíI-˜øÈ)£¡ŽÙkêg`¨À¯´:Dìáá“oÙPÕGï6¤ô+›ðešÛ³¸«7«Å››Î§‚Ôãt4ÂsÞ9ÙM5$g¶ËØoõ¡HÆdöKËiê•ÜïØä¤Zí¢Z¸Ÿg¶_ÁÙÇ+
+-ƒ¤Ü+ÇñM'xcÖS
¶¿¨c'ÔžÌ%no°ƒ1®¶>-vÛÉ¨Ž öá_Yþºd³^w9P±¹AŽÝôð5•S‡Y…íÃ;xm'G{Ç'+OÊt:üÝÓà@m'GcˆF» V÷7Ú-yüó»9nw*P4ë6Ò5Eô‹¦ßz1ÉAãâcÛŠ=¹´µœæë¹½õ=#»¨1­HÃÜ÷´oe©M±›xÓˆÝ´U‡Ù$›É™H7t1M@?“­8V5q7M‚·ÏªÖvÝæ¬/'D“7­™-Ñ]Ëh”žÒ’>F¾ždÖ·_@{Å`°D.&žý
–¯ÇËrÆçë}ºg¹€ÝÈ9ÊÌìº¨+I†Å5M‰# ¸Š9F:_ˆÆë6Q4Ó2îÂ--­³BÖ'išÐ¥dÒ+`e‘Æ¦®:a°1Ú9H²‡öÿ8•f&§Ÿ*á{šr3~Ú›³×V:âáxëÁVsFÆš,—ñöÞïcF[¹+¹ýø/2ùÛ-ÄòM³»ÖH¨ˆííÊå—å´,°d$}¹Xç¥J´DÛEž]b}'5ÙŸo¼%D4òï èã<ZŠ„S!äg—“|"#ØÁkx8c/A‚ ©úÄTúÖºoÎ'Yà¤®ç©3kxÏ&>¸Ñcí´zÑ—ÅÙy™˜¨Ú·ò9²Ë˜êYÏ8[ùsN4D[Þ”n,±®T©]Yãk„Z"ÏÏÆ9_ð‘'7H:çOu¿…³vÑ9«>ŸœôMéj™td%@Š‘|´Em¥}ïE@í`Ñ~ R•@Ó>n¢‘ý§¯d˜_fWž»«UM2»±8”=8[a”xv0ß}8¯pQzV˜Uc<¦-lrn,r3éÓtå¡¿f†´ ÷LZöÔKþ-ä÷"]†Ð­Äøú.,ÊÂÃ.ªÃÎ%nbä–xžNñ˜p‰§«33–Ú>ê$¯åw“§œ¶²äÕ¤¸dß+œ\x‹Ü¿3ñá‚º>ƒMzŽ8ã‡ã¼`j¾.¾œø«iÿåÛß_öãÿ¬,ýÞ=þïþúÆê­ÿÿùÝÆÿý¬Mñ?¦xçø¿õÕû[÷nãÿ>Ä/ÿwosumõÞÆmüßOþçÇÿ½ÝÿÚø?Œö÷ÿÕõõÛýÿCüjñÎtÔù·£¢š\áëâÿ,gýðÈ?r¯œý¤‚rÍ~5ßk+i‡8D)0g•)‹?f½Yìì•Ž] Ö;ÄôyV‰¦à¾……¼(¿Æ’×†ò9{™!˜{G„ë8ÂEbüLhÆA¯ß_€ŸíŒó³Œ‰~iÓ<Ç|n°¶5DôU.ŒïUvenscÐ3}: Ï:!›‰°Î¦.†j½?›Íº¸¨üeaY6øæbú<¶· >úFÍJ´ñØjGº¨fÆäkÄZ)‡tAKöH6”¥£lÉÅñÕ\§œ…Ê´þØêlÛð&¼ëXÙŸ¡QßÝx<Éf_·(/ÖæR·¡É°íE·$ÉIQŒ^ac7§[sjÅúôî›†ÒYo¨,¶tkaŒ%×ç™AùºU‡ñÑõko”¥~üL-XRŒÜƒb„T™{QfÁQzC.²LÁÑKÚznuð¿Ô^Å/I¤Þž‰çBCZÉÌ$ôæ%möŠ~†|å Iaˆ™Iy£Y.è
>ñºI!}ãÜ˜ða²ÉU=ö‘üQÃð‚à»@ÈamÚ/"Û…±JM=d¸HÏ8îð©ƒ÷l<]]pHíPò~ë-ÃÚ†FAhioDàYÖlŠ½S‚ð‡l¼C`5wŽÓWæ6ë+i™žóÙ6éE[3GÔEæ3íK_³	õopƒ¤B:cNmÅ|‹˜Ü–è&)šWÉs‘Øú6ßü¹€»f‰Hð+YàŸ¿LÑû-}çcZH6XA.ö] fhóF	4ë‹·ÈŸ*æçÃŽ¶¿À]LüŽÄÃ“ýeáÜ/¨7ø|t«_Qp9ÚÈî0þ/Za›x{ªŠ;ä+x>L+~§ `M_æ¼A¦jŒGÉÒ’=Å‰d¯WTäå‹©[8í‚a#Tæìî•ÊéÓtèð˜|ÞäÂ#67q§"osc«ÏÌWÍ5Žbèè¼þË1é¬¢ªæ•?tWÐniE•v>îÔŽµüÉ¯²3œK¯Ã=4D—qt¥è1¸ô%”Ö²æd˜—ýÎ¥ÉGwÏ×aG“ë…™*Êzb„>‡ÝµÊQ'ÍK¹cä‹a?^AÚ/û†uÐ:—nÄøµ\3½èóÔ<¹2!vaóm8Ý¿”äð8s‰Äýkçx’Ú‡¿°kÅ‰¼JNÊ,Ã(MÔ/öpLKàƒ•§èlKnJ¦‰® ‡¢#ìZÍa›¼Þ–ˆ_Žaµm'TkÉòq‘õóµ·é¾‰ÿuL[9ú"ýwÿ““û«t#&ê.)ZaïîöLZ9Ê÷s@×õ™‹é^Ë¿Û'WÓ¬S¥ôžÅªÔiþR´ËF…»I‡ÒiÞ×±‹úû´¸ì˜>Ë<ôýë‚ÓÝ:ûV3Ýx´»¨g
Ã¾|y ;÷Å,çnïZzBÿ˜˜N€Â‚š3™€öêwñœKÒNQ^<	’’RÎQ‘N˜;
›º#×hZ“v5f§›f3>é»bvoˆ\ù]™g¦+ƒm`›œŸcÔðKÞï2–‰óŒVÜE*ž|™ünž•WzJÔ–Ùy, ‹û,£*:itÝD.•ˆÄ@óÓNž"{]fÄd±ŽËƒ»Ì†Fª.óHÜu°¹·ÈB~§ÎóÑ¬“;ß°vò¬H´ågäÐzzoØCG¬ßê8Ä}Râ$ô€S…—| Cúà¤iÃê†gE9.öŠ2[I"?Ú¸ò ºË9¨æ“HçÔ­“º.êIöM­ù«­ŸÛóØÂ:@Š’ð>óU=@§;òn©Wå£*üÜ‹™øÉnU‡œp\ÖŠWÍkùq-î[ÆÇ$ ©‹ÍçHú×¤âé„ÍŠ¼M¼a Çó÷µ÷ŒÃ_G3.fˆr3Rá\bA;è®éõ1;¼óãH=3ôù¨rö9^‘ïË“«ZQt€•¸³ÜQ8À¸c˜Wj/î VZ0Ä	Õ÷]®n*N%Ìàõ }œÁ<ùì¦tŒZHTS+S(à/	0ÁtaEÓIy¿â*>VÈd¤Û¹&L%œ²ntÛ†}®AUeÏCâ)ê/œ]Ü‹}UHÕp“Úz“1Gë8_Ü`q7Å­©Ï‰ÒŠÖtÀy¢˜"ƒ$¸?äBP«b•{£œm<þwýºâÃ«×fQ|ÕLSjüÂë:W1UË|	Né¯B¢B9ÏòS™%¿wµÍÄhÿ5ÆUõF>E?ƒŸ'­|à*;çÇu÷ö©h`¦‰íjß¨^Î@gŽŒUi9:j¬…»HÓ>ògËÕõ½±¶9Ú-=Š‹ð,»LŒBë-¢ºg°o@tV.w#“ŽzT÷àun7s¶&Þˆ5Û8äzæì%ZÎ×Lï)½l6°¼‘ïZœx¶õ‘µPhOIÜ‡T ­î¾µM°#¢AL(¼[¡Øa¶~–5V/Óów°]×îFr®A›ï…ÄY<¸Á|Ø——Øý¶Ñô½ÈðM¶lß³Ûª®¸þQly~!uF{_~'q©°FP‰³5˜e†‹…M™ƒ­ÁnÇ:&‡ükÌßf{Å²ÎšeÔm†JÃi7Í×Œ¹Ù`@˜ Ù„V#1íž²”û|k—Ý1œ«Á7™ª^TŠ’p2H{ìPë[Þ9ñû2‰©’3ƒåÀ{Í`àøòÀô½lÇÎâ´ò…™GRcGr½ƒ
ýyÍŸµÖQ:œa7ûyeÀN€çñ^ÖÈ€(è"uÉÓ¸ç‹ùmÀ«¥Ñ¨¸¤ÛC‘êýXIAV¡³ñl„‘Ý6-ytô{;ÆK…§¦[PçEÅáÝðèÂPdró3žfyÇÆ&šàÝA	[&vœîE±72äÐÙ¬« ¿É|Q²¨ÝëÉ«ÇáÆ.£áp¡3´¦¨›±6Áð¢únnPÚXõÁX–,Ïy¡4–gd|1A2µh#ñf×üiÊ(ßôÿnËûdK†•~Å ‹Ç`”3±³OU2j"™eX­ô8%t†&‹‘3ÿ;!L÷º£2ï\ÀD‰<	.°îž ¿Í®'‡$c—h'ó‚+/Ò‰"œ„Iñ”†ñÆÂŸ´ec±Ìlf=µÊ8PD‡¢˜p_*¤ç)^ãû;ÈBayÁCÆ
¶æÕ¨fWH¨—……—£šéÄ¡Í.›åt?%q]|CÆI/muÍxDØøxÐ±[Ø%í”‰ÿ¯r¼YÔ|aæâK}4WYÊC†\•þÆà||ßMÑk<ôCÿïïÒù_îmÜú}ß­ÿ÷Ïú×äÿýcÊk×ÿêýZþ—µÛüä·þëhþ¿µõµÕû·îß?ýŸïÿý>vÿëÖÿææÆæ½zþ—[ÿïò«ùÿnp8@eÍ¹_ê ¶ÆunàÐz&e¸#¸=v†Y`ê§\qÃc:²J™¶w>0¡qÿPiKÓñ æR7QyÞÁ_?…‡ÞIS2*€AÍîßR’‡Ú‘Î×’º¨‘7–ñÈÐXÊœžüïÏ-\WòÃ½Rß¥?Ðk\ñ~Ûåðyìº)×6`ƒì3	÷U.­€D&XÁÎ©Üðòâ1‚[ZÇK1.¹ø†ÅSÛ	Ó¯ 9Š©"çi‰‰›s¼8„ð*üðŽk^%ÒÕ ÓPÏkè¥Øc.ðìFˆ²tÙAçX¬N’™m'–YÆ¡…Ù0ó¹]Ä†Ò-ÝÕŽÂ†-;÷i†ðª7ÁÑjÛâ‘–à{õR¼ŽS9ða–âÙhj€„ùQÖ¹ö¨|,Ù€‰1e"ù.x&Õz~ò……Ûc¸?¾‚ˆæ˜@Ó%-—C÷Çvr’Ž^!t®%=ƒbÏU“ë½Ý-Fh4¸v±)ù2»" GÃäâ†nî†…b¹f@.îîv³PëQä	ÂL&®¨¶¬ÊX¥™¬¢NÈÐÆ¹>Ø0ÈW}>ñÖ§#U¶Þõµ}ä[¾š¢Ì.i€nüï{ÛÖÞ6ƒ´F<ûä9É+±Þä&ïIþZzšl i"šq–Íx/BÉ†“f¾c1 #Û‰§–T^špK0¬Þ~qÎÊü5:­¡Dô_5¿¬†-Ï‡Å$#¯ÐQÄ›ß®­¯¬m¬¬m®¬m¡7 êd-3$ãbQG×“ÊÇ{PXeš©ßÐKÁÃ²€¾W"/Ï3Ý¼k8í7÷Þíä¥ê yëÎbýK)SœùRXîÏÞçòINI è~Íµ…€ö/eo$±â¾ó”AÏ zPàQpõPÑ	­/™tÖ–¥¸ù]¨ÍÇæ"!ëÛfÅyÑìUïÊ"†ÑE4EOSØÚì®~‹wþS§¨¸/·¶¸Ð½h!vËnÝã2÷½2fˆ{¯ãMI,ò7zþ½]1gÿÿ_Í¢õx”žWÃ|jV[¤Óy¿SÀ`ë°˜Îd‡¤›½ ’éàSQcZç„u®
Z\B™…Å\aJ5p†tÈj]-S~m­Ëþ·q={X}ç„UC{?1˜twï1håðªLÇy_ø‡œ¹VVÊÏé8O7vT¾À>â¥Jk9y$€¬ÖñSŽuØBu§H¹$QÜd­œõÎ»úÔ;(z¯v¦ù1;(àÐr9úU6{1mÙO$AÉäAÐRkùS)è>…j½ÂCl+µÕ¶ƒv¥•·Ëª+8é­;Õ°˜På†ö&|5w‰¡Päê…ë,Ç4z´±æ#&OJ™Ì`vJb[y0 5Î7’õÉ'óAòé2	ËÌargZC/Rø'ÒþÎò7f¬Ø$ÒƒÏƒqtÃ±ÁÖòrqKw&ÕeV¶Z§¦SPCØROõµ7óú	ã|4ƒ¦—i>SdvßŠ4RÁæcÚá¶¸¡vìûÍtG¬¬K¨‚ ·õâÑžNoDóSì?ØåzÏ|ÞF)•|*(Fª6¨ÚiåÕÎgág>‡ïx$Áÿÿv	±$tpË”ywÙ}Í*V•½Œ¤æw•¥x?¯¦xžiŸ5²>*T‰†´—ÇØ
]©—7dw¤:û¿ò–žÑ#ÇAÁ4ÑÛ.9ôðìÑ2lIå§Ü—¦É‘?˜o¹³Ý)§xÄ-yXlg8¥¹‡	eÚNŽŠž‰ùLwús]6(€mT<ÈeÑCÛ/;ÌG}‹'ÝYÖeÔöŸ7\f@î~÷ì
IZ»yÙÃ]É$mÛ7s	|ˆåªçù|ÓBlâ'‘!²þ;óDßz~_EeŸ¡•’ï—­²~Ëôð–»BîÂ´‚yYÈPNŒéF'Ëö&ýÎ¬èÀ$WCƒ8c@o,Rk¨Y®õþ*#kc¦Âfnåé„#b—¿þiÓ4ƒv‡Y FYlûÿóŒv	<ÒÊ,šÅúevÕÂÿÝ¡Â§g Õ“;ËË?ðól†<CÞ”é¨Šµ’a!LPëD†	;Ny6êCÚÉ¬ñ·Ùëéˆ—‹wâýjnÑàëFÍ³µõ;‘1ÚêìÝ¨WQ¿˜|b‘Õ¦‚Ö«œp£òÖvžrAèµË"nU÷=K‡µ8€ìšŠÆO.ñt#TÓûÉ§ë·ð‡\eV;MˆÈ\#´Ò]Ù/÷©¼=j—â¶“?BÛ]ÁYÿ3ûøóOÙ*w–Á10ÛK{Ã–ûFâ7œÅÜ~j&¨²€Ivô¨åµcIK_Î.9ÈÐŸ›ƒ§¬Æ>º‚q³Ð=v-òz§îš=ëM²pŸJÞÊFåuõÀ.>9BþEÖ‰¹‡ZoøÇµïmÃj»ány*²A]'Å=Ev¾b­^-óY©(¥jÇ
_¤ÙCàì]Ð¾³þWÀS­;+&TîN#å)0#½|V«›Ð¼‰r¤ÓSyâ[w¼ìkw–ëôuu¦ŒµFÂånIß©`Ì|"Û·ëþ‡‹Í¥ óV\tÉ>eÐ€úJ´xk	)Á²V+g'÷^Q–zF{å5»¢Ki¬bö7f´?|c¶}io;™•óÌ<,@!¢Ä´²ª£?¼UTå¼I€h¯phûýä-|Š»Úú,Sò¦ÛíÚ>½MV>÷Nµƒ!õ«cOwð|V<ÌNÊùlxÕª³š¡­o¼‹¼uÌb–q××´	ö\ƒÝöK­×K­ÛRß4ÓéõLSIÚ¬‡ñàéä[3QÞ`?ÏÞº9zðÆÎÒ”ÔÌïS77¨MUX¿vx¡W¬>¦XÉê³ð|²Å©ôÇqŸÞXòêYúË)ouãp
ì‹p.ì‹Â„+ª¡½U¥"SgÔúrØ9/PA›f²&¼Õ·D·ÚV¿©É3LëáI²GÙ¬x­DVdü±¨Õv†yËßZuIÏÂ—-±]¾Åã‘ÏOJg¸¦…2Ã!QË’6Â™²ÅÑ½¨¦ÄkõO¶vŒi]uó~M{'5Ø‡âªy´5VÃóÉt>£Æ@·ãYoRÇ£­XÕ;ÒPD7ý¬©ßÑÆC…;6b/`5®z£Ì³AÛ¾Ír3:žÔôâÿLÜeä>¸ŽÃkx/	‚ ,aøâ/¨w˜¡Ñ‘¨çm;}ó”/÷˜£vk±[Œú1´|–l4fþ*Å 	SnMÊÕâ3WjK’i…_H2`ÿ%½0W<xXÏ¨¥¯lJbôTeþìaE«ídæµÂhŒ¬OA2³¡NA|ø¢¡'û¨’
C}ùe­À3$÷ÈåÄæþü²Nãò‹m­þR]íOŠ}º$¦‹æö•Q<IPn‡¢M™çR•…Ù­Ì§úKy
yp+ yJsácR?»Zpyc®x"›¬$aÑfÓHª24*ï‚fóÝªY1½¤àØèµÃÿn-w»ÔVíHÝd";¸"¡ÿCNé¶]üWíµQëm©l”N«¬€Xj²þÚÀÃUuKkcuuÕ·»Ç, ¤S‚@*í]è…Úª6OÑCî<ÃlU³¬µ_…Š áf¯iç¹ƒûuò×ô fùËìŒÇ½t€H˜¾Uñ¬è#ôêež]vÏæùHiFæ‡½ßÅmÛ<î(›œÏ†íH±‡Ü‚³Sb¾03<üÎI“T2ç3t‰¥M‰>ñªõÍrøàÁ1jpÂ]™H=‹1BcÕsÏ¤n¨µÜÆ«Ì Lbä0<ÀýËlNÕ¸(äÈrYkRHâÓ>žš–]“a^%—¤Ôœe&p_ ¸
Ê)ö©!Dã(Ô`~ÉÎ.5¿¨ŒOòÚ­	GqE¾‘fw1í¸ÌÆpƒ/­ä7ùÃXƒ¥}B'òrºöç%;k©äO&ŠŸŽõŠg&;Òµ}ró!½í¥ÐSÜð@±5qÿ‡ÎrN­n_©œ÷ÝŽ”}¨d(RØ}Å”¥ñ):œ©´òŽ²ÑÔˆóšLx§œWÄ”7<…%¡[A_ÑAz5VL›ç:dø¥õ3£H%_I¸#y¡ÅänSæG¥&Q/Bf³ Œ°žWÜ£¢MÈæX]æÚ­Ç¡Œ]ãŠ¼ä7ðR9jÍÍµà@cêŽ0’<Ý‰1JÄJ®©O¾ë{ÙÒ³˜ó¬d1T‡ýòÃ\mÝBàZ$	5‡m²œäòÕZà£+8£éhòŒzöÀË’ë—xÎ°®Œ=M¯d6í§Ó ¬íJ{Š{†B2Ö’›ÊCŸk_2Ù‰É'“ÂoÏ¿¥®T3A.t…:Ù¸=eÈ¯,1lrT8Ü‚"cz”x_‘—‘’ØÌ-/È^ŸÄŠ5	ÅO°Elÿª˜Ál!ß÷ÚÌö¶\ofUE™Dü·2cl–{
Sƒ&EÆkø[õóqÈ,è.ÜÄÇìz6SÜÜÄÀBÖä¨ñ&ž
Ü°ê%ÛÞ§äØéNû,Ó~÷róv×y5¯¢Ãº[¤#B Â¡ª3,OsÀ‡×˜2dYÕŽ1RÓ$ÿöYùLúq“`óC+Ï´EìLGœ†3L½ÞÇ•–ÜäËZ‡18m×]ô^(©«hþ×ü‡UA¥ahñXÊW×^ö:vŒ‡–¬rU•žKŸÝNø.üŽÖ€‹ÉI:%½zVÌžÍG£f…¸ùãípèÛ6â­ïÝ	Iýc?Õ:9åiÆg#G°ÑÈÜV4ÎhÔ½çÔ»®E…îå0+³(ÎýŒÎø.Qí7]¢ÍhPWÉƒtç±¬«ŽÓi´¢WhVà éÌ©{Ø¶7IrgÍyj¾îŠõHë†³zçqQž³Ä–7ß4_$'aòdQïÙQ=|™ì”Ògš®½¶:-ÃÓ<C-Á^tÜÚ˜T9©°t“MzåÕÔ„oH’ ™ ;’HZ3I˜êÃßN;¼Óqû”BœRLÈ«>Á³t4'seWÏ&ÍM?]9yzÂ"…q'ðMŒ	£G Yí&_é0p oWQ=ˆ&6éäPoê8îÀ ªÐºO‚s#H\"ý¥ÞBS¹ôô‹¾B¦7D NøAúéŒÏÒi4 Áþ|V¼Ž[cÈRÄþýÃbæõ¹ž­Ûi#Æ‚úü«ãC+QLAáTG­˜¬mãvÂ
•¥DÜŒh_›°¬1ì¡¸ð‰®îozj6Á³+4‚[º…›²ý‚&Óh5ª×ëÎ.¬Í‰ù;r”0®„–¦–H­¯Û;µ Ã•¼©õó$CÜw¢ …xîã†êã®$TûttaÔuµ,Ôr;Gîºú{z¶w›ªwþÝRí»ÁÕÓ8CXµ¼×¦ÑM;çmV púëVWˆ—æºmÍá[Ôí¹…~ÚÅé,`‘M‡Wþµgçt»sT3‡ã0
Î•þÒ“}^„ ûü¦—'“ùø–‹˜m|‰:m;¢„.:rÛ(L¾¦L@î½€4©b»vYØ-ã8dð!miØó3_“H=V¾YÀXùEY®H”biÙr¼VáO¨5I/¿HË1­1Å÷h”#b&šVpÜZt­‡‘›Ö
a±	â“ï)h""%)C1˜!ò::çZÃ¥„)èeCNCdF
DçÕÈóù¬S:´ëqšf9ƒåÇ;ƒÝˆÑt‚9Ã’é¼„åPÅwÖãù™=ËÕvVL5‡ äWzŸ ÔV‰ªƒ¹Z–v.—$\OÍ$0ç-ç.âªH¯7>ËOæŒvX@g®Ç9¨Q1CpZí´Ëx‡_ÉÄd};!Û OéA@ñ Æ[ÐŒse=¡Ñ¡aGîC@cf¨‹]›¦=~ô¥ûqo³ƒÍi‹ÎqåÙœ|ª´Nº˜•&O=[OÿG:Ç³ÌIF
Ôž.B‘L@¤£¶ÍGÑ…1Ì ºMš›A‡¸&„c´IAO|euŒÈ‡ÃS·¸¤`ÚOŠtdïpíS¦¿w{k%«íäW[¿ü†ìIU6+¾¯VZ…Jl]«RóSÞfc[ÏdƒAÏXEã€a*€ §dGKº@G*©8B¨÷kì–Dþ)†0V§v](üò0: ÈÉÜÉ«zÖn¡•DS…õBáêYƒCýDñƒÌ8‡U#…ùRÄ~¤BGäõH†pÐ
 æ±Â7™­^ÍÇHc^ÆÑà]ºaH's¹NÁìNI˜®Lë¥ €s ˜GõFYÉ¹•–"1øZÎmä§þK<Qéâ‡wÛQßôðßjéãO2Ü3Žèô*9‚ž+“¢s^ØtcÄ´xÉˆ”7ó„ÀU€à –F#<ƒ±²R%¨YSx¸Y7Ã½V`×[zû	KjâY²R@7‹Zs§)ØwðáCkT1[}Ÿ O5‚Y@¿6Œ¥–:‘Bý…À£m€ Lí¶G¨Ç¼K½cÖÓ™Õn,mAÆÆ†0÷woOjÀš†„¾Œ_¿ÓOFù+äb›¿‹É5˜?ç_ˆÿiQND °wÇÿ¼¿¾yÿÿëƒünñ?Ö¿&üÏS\»þ×Výõ¿¾zÿþÖ-þç‡øm¬Fð?7~µ~ÿ×÷Vu ú“ÿùøŸïc÷¿nýolm­×ðWo÷ÿó«á>2,Ð„þ¹£²C»Â×:ô|²Ðõ³lêA6h)ÌÇ ü3ºˆÙÕG’!’‘Ýfçh×Á<—’ÀDÔ6Ê®ªza“ðPÌ!£–Ô(Èp(P¼»j†÷ähÔN¿è}  Íˆ¡iY4Ý±26WœÕA3Áúš6&î†oÝpzàZýùuX›zrMŽ¡(Üf=å\àiâp	k¹Q(+RReÓÔØ±qúÚ’›°í%ò³ …/ª†ÜI:K”l-
sHJk™8Sç “ØÄ2x‚¦+ŸcÉ|Ž©Ì­Õ"|M„‹2kø¦ñ,n›žÙÔ:šØç‘”:R_Ïü¶¢fs>E2šD`¼¼¨e_ªA•šÚ»Ýý•_ûfæ%ÕSçq^úY†ÝÀ¿B“T˜¸JZhŠjK¦Cg{jkóÒr#ÿd^Sš¯QA‰vMÂÙ³Ci¤Ü—hBa\r œAf¥þo€Ý°½ìGÍÉ¤´I,²ÓÝfrr´>»OštVlø‘%òkˆçJj8Œ¤Fé//½8§æY ³Æ‚XÕvë[oÉNNMcâ! URÎHÖ¡×ßªe• ˜©l|"Û&õácK%]„vŽÓÉ÷¢ì½ÊÁ@äæÆ¸Ø7ÐŸé¼ŸSßwðd·¹IîY² iÓ
ÿ&œMµ;X”MN‚t“ý?²cÄ¶íÆ¼SMpÞáþ°Äˆ™öó;^þ¹XŽ0Ïiü ÿMó×x-ýÏÿøŸþ´ìý¾s‹çOù”¢LGç PR·àÑŸ;+Jÿá¦5IŸ?r.ÎT‡ÀÛ¬–d¸îgÃ¸«ýù?Å[AãNN¾Žäm7H* âÚô“ÐÄ?ýÃÿf™Bù™]B?`QaÚ¯‰Fd#P4þöú?ÃÜX®¯vâÎ’Éž(¸`§¢Ò";óSÚpívóüÔû^bêä“¤bÏ—ùÌ U¹“ãÍÛoû5¿• 3q¬º½['GÎ8¨S	G3 ûM¼Ø—ïs¦ò0]ªxz×OÖ)½tWå–¬àIkÏÏ!¿¼í¦„2f'@Jr¤Á
À¿L”;}ûsîìÐËƒüu>	J w'»\^ðÿçn½12ÔÔ¼êºÂo—“mÜ²²¥¿Õ¥­éHœD±9JùzN1;ŒÉáùšÈaÂSv}{n"v>Ã:„¥h‘´T”è|>SxrÌËÛ¬8Rô6ÙÃ½þ3 —rõÍÇž1DÆ xƒsÕ'µ	ÖÎ”%]„Þ¹ »1ôˆúåÕ¦Âö57ÁN¢ÆEôîúr
+ß²Ö»B¶úÛRJúö¬@JÍÆ<vú×áœ¥¿ÅËÜ2§MOæÔg2
8&V€6ãÂÃ¸1“ð
| 8;øÆB~ê•`v¢,Óe¦´Ñ’†]]¼ÁkÂaÜ–C>
èþ$›}íh~”Nù×lgÍšGŠâÐÔkõø–+<Í+!ŒŸ€,ºÅYõ©{ßg¼£×ÞbZV%XG~Ü¹cªâ©¾(Fˆ¸‘¨ö?W_ëb¾V‘²­þ†Êó÷>ç»R°£`XB¾÷¹|Ù•¹!?Ì€Æm=ìPÂîàÆ©[Fú¡ßU‡ÀG°¢ønÃ~A­ÌÁÝßÍº³‚	`|Ë=-	M§”×¸(©¯L©s_Tð‘ÆœCí,r„Rm@q<9Ù5	QW§è±²8Þøº(`}#¬ŠÐêÄ‰'d2&Åo¶‰AK!äA– áG·™ÝÇ»5êÏç@Ê–éSÛïFÛ}Ë¼½ôÖ"ˆxD	Ô‘·Ÿ¾“*À9ÔO`4¯®×üy9ÆÄë*ºÐA¿5¨kôVPu¤íX"e·bÎó¡¤,”Âî[ÛÉDbQÞÂbô;>D=¶—••iµÊfOMS-Ïm‰BRè,"¸»n¸Hwš^á3aý¶iñuõÚæDâÅÚªQ¯1û¡=ñµ_2’ó‡}êmÛÂôÐ–šÖ|òj	Njxòæ9ÆÚBkNâi¦
'Xw73É+ž~"p8§íäMÂ8hDcòVFËSMÇ	nd4¬Ç¨³Û½©GSJG¤•“¶†×/.Õ5j–}"æîßÍÉûÅ-¡§˜|æ2Ãÿß°†j‹Yå”]VøØUPñ>ö=-SV“h
"g«™·0,€‡íÒp”rVžÁ‰Óë–™ãÏôÓÏ[-`Ì6n ÔFËuž×n}åëÖëk*	1Þ@rº	mVg³ànÄ*ü¶âú}¶_hâ®*}ò8¥¹©%YlÑ‰ð”Aâ¢TpD¾(·ù™i>&ÅÌÄæÓYÓ${gœOe2¥¬OãaZVûÒR;”z³0À¶î²HQ£3ë‰f}¾{wŸ¨W ¸klñÊ1†ºØ“œà#Vm§éäæÆÆV+½ä[¸MJ#î ‡pH@3ãM O+û?îU3L[”±õ†òm“ë#y4†AÙ`€RLLÅŒQµ’ÞQÎ&ç™¸2*‹ƒ¾ƒýâr›/“ý<Y'ˆQòQ¡Ôü‹Ïh'ùCò»Oû¹¼<Òs)6yC˜$0ãWÚ¿1R³ž’*H¶]O·Î´·ý“Xa»¸›)pÚïÍ¼d¦
ÃÂ]»{¾¹¼òp·ÒÏ²)%*§q6%6Ì$8}hñ	Í/ë\ØYw•ÑË2c–ª–kd¢AFÃBt f×mËÆ[üj§ßÝ¨€{\°ñ
bé>°7mæWî+þ€Eã°*{~JQßEƒ¥ñÅõâîxbÈÚ‰a|U€ë(bæ´…a˜ÁiÂŒñ$^ÒÑ©tÅ°7Ðob39ÙÈÜÝÚ¾¹BSùí÷‹]
Á@Ø°R®HLUæ£/„àXi×£+OˆMàÇãä®ËõŸò ­Ø[)¹ºáÛ¹ìlÎñ…ó„Ä9K÷õ5	uå¿½&á$~‡ûþuŠqF¿1 —ÊÉ â›Àü~Œ,Ð¿)öÝ¹åõûD²¯#÷¿Hû/A‚Š·®¹¼óµ)bçù_ð¯w¢P~£°Àÿú ø£þ¨Œ4…*Ãòî]YSº®x¼Õþ–Fù-/'ŠUZ£eF¶ËŠÚ0€Wv‹!Ö!ÈDh<Â9L	í	À¸ÉèŠZØãÕiØ‰ÚtNÅz ‰ôª(kµÁwØæ2Û „rÝ4º¤E“¢OÇ\9ö­Àb…A,“±·ÎX&©­'¤Ed~©ÕiÉïº¯²«¶X€õýÚzbÏ	ì¢½¤P^Ù2gdHçŒ•/aÚú·)Cªi+µt™íÒ¤ì²”J¬´ò¬Ô»ÊH,2ªŽr¢ÛuéXÕü¬VF9x©’‚ðaÇ®Ä]`jösDûeûÇ aÒKmÊó°¾ðYu#¾}œÂDSÜxÏøU+A
j¥@Æ°Rl`/Ëg3ë€‘þÉæ%j^y¢eÐUõœÀÖàœ¼7€ ½ªxUE„vœó=¸R„‘•ÿT†C9«*I«¬'Æ^‚“ÖÏì¦áÐÔ&í·Û	ÿK™¤æ°ÏìÄRÞàÿGtp¡æÍAuØË …Ã.÷õî³”¸s°"å\I¶*¯{1,1nÞ‡6mC²N¤«†µÔ–ôàþƒ~íÈñàû·y«ûóàþË”€Å‹ï	Ïà ([oìRbK`Ö“½ƒÓ/ööŸ|q¢Ö!;z/“»ÜŽ+äýùvÙaew”O§Yÿx~†!Ÿfœ¾>)Žh`ÀqÑVñàÍÚª©z	M—ˆvåžò<}jÆÑ˜þIûKØ5"‚ÒAxZ§Zª­…Ð
”¦þ'xàfLn>$.n3r(9¯¤;,ú»ÜåäAõ.Ã[Ý	n~ùÆãsœNþÂ5w9Ñ;óñn>¹(^eÜÖ¯Í;;$¶‘VrídÌJl öl²¶Èíg«sYãî<Na+ècpî+“Ôbãl'ý&3F¨·w<ƒ¥•áh&nÁtí¦c8Æ{“.3ÅôL	­¿~=üÍçÉ,}•æd1(ÍÔæ½W„¹DòüþjE{‚xKBßN•îâ¨¶ÛùÈ¾ÍÓÝuUƒa½†}×êÚ¯×W½ç_íc‰¥^ÐÇåHŒÝµó€L6•k¾Šƒcž&1±‘žH$Ž)³˜y<„ó“{·E‹ê|[›þ–%¥Ç\šOÑù˜n ÞÈKn©Â;Ã²'îÕ›udÍ}º¤¬ÛÞBÞ·éê/Âmk§fƒöçÊíµ²ÝÔè¿w]¯ôÊ»Æ€MÇ2Ôy‡‹ü¥¼\ó|Ã;i¡¦‹­;<IR^4ˆ¶ºkÒµZdö·BJäÈ€œ³ƒïk2zrÊ^7 ¶²}ÓIÝ³ØÚÝcñQ¬Ë	´º#–úÆËe5(GánLóíÍÞz›˜oè!õNl7þöå—ü#è%½Ù~èŒÆ¹H8;ãÍðXÛxDé½:)‘+ûOC?oÙ¿˜p+}cëÿkNÿÓV·u#êœdfF/Ìôéf–2 ™èCFe`¶Ò&©†Åeõæ|"¾êšo»¥$^kxqÈ[û£rÌ¿C—¢qÜ‰ú'æ“öF½3©ÕL
D{)ÕÀ
à:[)éª˜ë!¢Ÿ!ì†9Þ²²o-Ÿ-aB :ûÂjÎœŠ0t…ô-¥r$ƒÐ5%ÃØºÐ¢ƒÕöâöÌD±#Õ0’ÅÆ¡IR.¶”ó”,¼bËÐÅ«O‚ï1v&ðòv¼ÏþéWA‰ç}ÂÚÓá¹óÈ
Úã5HíO…<Á.++–`<W½tŽ÷´gWÐž+½TkBà0XÄ(ózeZéº€0CÌU–ë¨Ø¬Ì·q¡8JvÍk÷ÏŸÑãÇÆ¢°ò¹ã:YÿR£yêšiýÔgMçpÓãIv:ô«ˆ)Ù‡Tö¥F3¡kTÑOãÓšW¯õÉ$0A.G»’¸h¡Ç¸k‘'RÌeÓ|°{‰·&-¨³Í©Æ¶TTŒä	~C‡‚è§£n„Á7É}Ï|Ò·˜,¶ã=‹|)$&«X«u¬õ¨#µV¼¿@ÿ’V1î·ÇÒaÄ?V¨¡]3•Ž&w\0¥8¼b»÷Þ³Ý£ßžì?vúåÞïÑ£:l°ã¿ó©'˜záÔ±X²SÄ*M¹B[ åK œØñuwöŽ»ò¢EMµyqø½]®¹¼)çL¡A·âƒ~‹8Ç~l¹.âxT>Ï¨1ÕÔYñÏhM¤3ç®3Òc"åºe¸Ñx~xVô~Ö@*yÑ²íÄÉõ©æwÛ˜#¢mÚé¾˜~åó}.Mc ¡“185T¦ýãFÖhj˜3dªýÏp¦{ZÁŠvLTÓûøÆ}om½þËÖêÖÚmü÷ùÝâ¿ü¬øåýÉk×ˆÿ²voëþý[ü—ñ‹â¿lþzíW[›÷Önñ_~ò?Õ¯¼—o\·þq½øëóþ*¬ÿ­÷Ò›à÷3_ÿÁüwOùw?*üÏÀÿ»ÿ¸Õÿ>ÈïVÿûYÿ‚õïÔÁQü ü¿Õ[ü¿òkÐÿ6Ö½±qïVÿûÉÿ‚õÿvÿëÖÿÚæêÚV¸ÿolnÞîÿâ÷qÂsNù¢÷'~Q^Y`9¥|V2ÖzÞ{…×Ö%y8~Ë|+)+È^êÐÃ=Ÿ¢|EÁ:#ÛÚÇ'˜îÝÒ––N†™kÍäÝì04ÒrŽ´™’‘˜›"C°7†Ÿï&û‚>V.SEžRósò/¥›y¼{Iªl$wØØ”Qú1nk.s¼”gð;8¶hÔ˜b©Î[P)/m”©`íÊx9¹™Ã™.†Oþ1†§Iô^6MÖèæ€úÎiVMß‰¦†”—ùh”¤Õ«mjòŸÿñþ}òU6‚·d¼¾†þjié+‚]Çö‹©!YÊð4Zšüf	£ªž`Ažúi”]*[¾G¥Vrü2F[=,‹KÛÈzAôðËÊµ¹´tÈ¹˜º}¾&XÃV×·Ýí;mˆvôˆr`Ñ4S¼ÒÒÎ€/1…€í$Ÿ1áÑî?ü÷\Ü„ñ`˜Ìé´ìƒøD_‚½Zé½j/!@§êvašD£aŠˆø^J”­ø›¥Öï¡N5¤äÚ°BW/E6'n”ë‹^†}!:I•‚ÔŸ¡Ìrœ2W° û“"$ÎÆv¢2¿™•ÐRÓ‰w{ËK±vviø cúý\¢>­Ë¥%§¥ßÿk)‰<âÐF·‘ërXà†ÝL¥>“ò1§È3-0ËNÂDEUulñ#¼®žònTãE©ÈÊoÓ‹”#0–/¼•‚y1«ïÖ·)gÈv²ÞFÂo„tßÜN¾2ƒpóåûC×¶HöME’‘?Û”ÞÈÍŸÉ–ñ­€žÛ%4ÒoeõZ¤6XjÑJúÆÙ«¦ƒ Üån]Ç{sfÔz³g¿êR’‘l`€«h+ÑîÙ¦j)+t{”IÜÜMÒ	Ó\ÅêÂVOÑö‡LÛ„’Ó2#V©ò;Ût’¡@!9‡ˆ‹+},8Ÿš‘M.ò²˜p¼íÁŽQ62|œ;ÈÏç&8wƒ3i¦ý(»Pc–í¼Q_—º¥ÍÑÒ¤$„,üycg¥DQPv²s“§Ùt@Hš\8§}Qšƒš~p"	æ£mÛbÏ<ã„r-c/õËúaóÙt>«Ø½½ÝŠî,¸î0n}[´ ¥ŸãŽ(X[º•ÉZ&{dùémõ2¼+ôôþ§ÿøßRÀL÷_‰š#U\jæ.r,0R†üÏÿø?þ_|,Àð›ÛÉâ]©û?$Œ§K ¡Û	¡ÂŸ->6$ë	¤xž€€ËXëï	bœúsZèÛ	Q2,Ì2y‘VNr]:èD@“&Çmd\tÇ jšÅMí#Ë25Jî:02§¡žec²¿iê'/¾ƒ¤‚Ñgc”zvcó¼V2Ç=[×$Mþãü%Âöƒ@	Üà—–þÖsF«œ9Él)Ÿšé‹ŽÞb=PQÌÈK°/#´%ôÒiÖ6ÉÞàÆýÌ®:uœ@qÏ2X#yQv]D‘Þ—–2—sÎtlˆm•wŠ–™Ù^ÍAÈ‚Rø}¢š]~f@eQÌxsU+ëýK4Û‡ö|¸œÒTuÞ_µ\ÂOp9Ï•N²CY¸„÷æ¬Ïû¨ÍN\ŒÅ0fj“k) ]äA9 :>¦ÛÉ”6 <àk¤5yá	V<XRH-k­a-+XHÁš‹‡1iI>ØXaa3Óúõ%õ’hªb RA6%­e¥[ô¢,«QWeo)‹H±I‹¸q)–—‚–Ë ‡ÓZ}PEÊ4X4L\T¦œØL7ƒmŒÅð6F˜’Œä¤ ´BõŽÓyÀä5Çí¹ì“¾ÃbÎf½î25bRP¬6tñ§6aí‚”©Íp?ùªRóCµáÉ]åÆïÈ×Ó1g$,³Ž[1á=ƒ¢ž^ªc²ÕqK¯"¢õæà|ëñE^¬P	"ƒc._£‡-°$Œ'¯ª9¦à`àœr&<yâÌNì.{|Æj)ÄÌ<!J¹óÖ>Â5œ2Îá"ÅÔ@öÜ½kÙ	8Ê{<4+<oVC4kÉÁ%UrŽq#0@0£è¨LæS¹´Ò$ˆ¼ÏPG' ‘B¬g,-=GâèíÊDéÈ'ª¬o$º`ô÷ƒ ûnžIúI‚áã›hdÇMý!c^Zp¦ŽQc)SL¯+<,G£ˆæÂÛ6Ò*1)02‘ï
cÝÅÄ®>—¾Î‹Y+þöHÞ¸ñzÙ¶Y‹ü÷ aŠ&>\Åü!>*Õr”šþH¥ïRÕ-›D‘0âÙ‹¦ÁÍÇÇ' !‡°GÒâxLq;ÈëN~…Bn{Éf)Edí4[ÙShå_bzÊ+_Ê&©s¨3ì’MczWÌ+³1ZT|Ëq~$Šå«³ù§Â½§4¥Ä4»&{ ›.VLö€'ÄV#@øÇJLc¸ÅdùÎ°éSœv¦)¬ÛJïbDùtŠÓ¾bk¬|kš3g>ÞnÚ$úö_ú2âö÷ÁÝS»§¿·o¼»ÿ÷æÚÆ½Ûû¿ò»õÿùYÿœÃÏû“ïîÿ½uïÞæ­ÿÏ‡øÅý¶¶~µ¹¹µyëÿó“ÿÙUÿ~\¿é÷îþß÷ïoÞúˆŸ››^Ö\.Ê¿àïìÿ½¾FùŸoõ¿ð»Õÿ~Ö?·þk)à49ðîþß[ë·úß‡ø5èp ¿¿z«ÿýôný¿¯Ýÿºõûkáþ¿uÿÖÿûƒüÌücÚÛ¼¿»\í˜2‹µ%“Œ)’^çx€rYYQnÃµî*üÉ×­œfœmgð1“í‚B{Ü6ß¢GoyWŠ±‰?zóæìë¼}k;ä%š³þGKKÎ2¡”îÛÚ‘že0Œ\àñ“´ªßQOA
x¥Ÿê¢^b]Øs…É—³˜T	8ŸäP§Ž&aüá:&÷{ÛöVø(âªeS¸t’=„´Á»0ã7pQù>/õ#¿ÙZ°cIž¡ò£³GÏ&C‘Ü.éØ%çÚôˆbòÉ5L'–½:wðòåþ—/îMZß a³MSƒ¹©1ßX&Îh|jb`ëCÌî‚nKžìà#ÏÌÞëaÒ¶ E8	L!E´§‹Ê‚ ?“,ë×ºo¦Pùè®ËT™mÌó 4³a^ö;Ó´DÀÉ‡¶Îax“É>’Ì%°4û1ëIFµNEÞ!$÷œ´&¾—–Å·TœHø™üg½÷Ø3Í[šö†xožŽ”c¢•XÒø\¤ ÒæRNZ_ï&ORâwQé Øó	^çªõÑ¹Æ[§uxôh™dKnRîÒT±“ ^ÓÓ-›nû„XÉùJzß­»É"*R^¹ôÒ&®—hÏ¦¹f£^MS:¥bT Gö†…K°.hZA+žsYØ53í Æ•£·»%G×1û´1²„(ÒpŸˆÈ~ƒÉ»\—«ú4ÈTcØCõj;ù:‰˜ï|ÓM¾"ÿHôû"ì%hMœ™ÛÜµj>áÝÉ^”Ö‰»56ž¶Sä{ñ›ü¡ot“ÏzeNÜ§å|”}ÎN©e6ÈJtCàO¢×t#ó.£ã¤MÒºùQ5ËrµïÄy$OsúÊy‘Žªîg+~_ü¾²[;’Œ$¨e;ùvÁŽúí’• œ¼aâ*I!…MÊî¶g^ÚüR"BòÙæiÎyâF–XE©Õ™ÓÍaÒX<¦#v¹y•Y®ïÒ—ycfèGÆ3«oØÑÖ*Aväi¥ä%M¾{×“kªh *.ÊûÍ©låU‰mˆòõæTv=#Eß¼WÙÄ6
/roÞ:ä©Ë*uZ°íCß½¯Æ²ÙóW•ÛÄ)§a'¹bkË0HåK ¼ê>æ¸„F‡Ó®ñïÒñWê½ïÀSóç©`¯Ó¡>ÂM-05Z{oüç¡¾Š·«)½çÜPêÄV>*Ð€]Œ‹ÎW¨Õ¸@ók^—Fw³«O´Jµ./¬’Eí@±k‰ü/6uVªIž&ü þ¬Ì_ûÛ ¯ÙnÃÊÓÙu8þÄX´ZCÍ˜Û È¨"(ß¼ù8CŸ1ë©«7ƒoÞ¨W§=Tü0iü[žBýNåF±-`Öawâ‡3—mCUq'Æ™œ¿}»²ELeO
8Ž{íxZ{ÐE3r4SØ¢÷®Þl¼ÁxSÑFÞ¼YARFdÄÇ¬Í|‚yÛD¿>oä*Š É”‹

[…G¤'<;µ\çÍÌÓ,-Iû†úZ?âš#y}ÚÃ×«òtTÙåsò×©âgÿ£Åä¼ƒ‰(AáÙ‘lXtàÆîé©É6¥ÌcJH`ÚÈÎí˜xô«ß½{ddÓ
N³à"ÂÈÖ=)Ó>l|ƒA•ìŠÛ~ÖG‡µ`]˜6gX‹+2 äi”éCX9Fb¸ãÄ°–bµƒf`Bhc’»³–GÑPÝÉ3¦§=¤dx'W§\„2‹Ü´}¿Ks]$»vù“Ç²mßhkÖìaø³ÛA?äÕ÷ ZsÊvÿ|ó†%÷éìGêÏuÿÏúS:dúø}ÇþÔ?oü—m&	á÷zá™~Ùëáƒy ožãSû}~Á²˜§É6M¬ë?‚&ñ™×Ü1ìV"ç¨\g¶=þkÝû+h‘zMšüŠß“¼ªf¶5úc]ÿ´…Ï¼¦Ðƒt>1}CZÛý±®ÿÃgª1ÍMµL’Õ¬×oú,¢h¢—3èzg½ #vœ AüºEé¥ô¨• J1x5w_·–ÅWÛ†Hô“Mz“…ü?[—H–¼õa%g>HòêTvp»¬1ŽDþé‚LzE™­$‘¢;ÊÔuú“¤¦xØv
¦±¿šDitáÕ­í “7Çéx[\¿t,H¦ËA¶’¨¡©S’<bÅkHe‡p=q¹u±I—s!lÉP…]{1“$µ’Vb²¬ÿ°!ÄÓÏkðq¢rÄæ&GlR)+—ëˆ±Æ­„mHòÉÓôyPõ¸œ$W¼rþ§Ðz{ÿ÷µR’lx…{r”AUB+ÀÈOG|]kh×„È~ÌçÐß?†FGŠ2¯³SlÔ:Q÷ŠôÑ¦Lö¥N¬‹.2­ëIb7›a|œ<4–›Ó¹•ƒÌ¡™hùÚöwß%†¾Žó*ëzë×³sâ»H#¦úØÎ©NŸTéN²8¿[K¬Ý:fYéa¾Û±“•U2þG¦PÛ—;Ç=Œô•ìœõ±øã‘R+®º¬!¼6dª"t)ó¿å3„*••Íú,daÀ_D@›ÄÛÞúÆ	ŸWdSô³s‡õ+]8]Ôœ¤ù9O­Wó™}Þ Âí§å ’˜š…6n{ LÁZ”2”Ž Õ’%M¢œ³²öíYdc«sY­Öë!†‡÷ÃÆ= Ë	-ì	Ñ]¡Æ=±=3Ü4£ŒEÑžFr3Ö¨©É{§ãkZâÁÙâïBÙ1]¡:½dSÐ7&¯È?ÁœÙ}ÕD[Rý+^¥ç[¤
©!
äuÐÇ:s–j¦õ¤8*æ˜ó[°é‰‹V;><µJQpš‡A?åAÃZ6=2ÔOáXÇŽ”ê9J†2Ó·Îaó{2OË¾ØáïÓsü;Pœõ‘ø]¥ÒÇµäP®Óñ‘<ÍÏJÌ?ŽeÄÏCkjïZ œ±ÕÞ«SOÀFî3Õcâ>;Õ´Cué¦È«`he—×<o\V/öW^|ýn+
Ä¶¬¤œVª²°žÆzI´M´-e¤£zmÑMêp!ª;],Z:òécFtPÄ¤ï†6mêÍ)wÒ#£K\îMµí”™é8Ï¹!qŒ	Ó<>Må.ÀgöìU.¦Aæwý¨‰åÕðë™aéÉSôå §d÷Zúy(ÉòÆNy¾N)õ¤O>Þ¾8›¶ÜÎÈåkqºí¿ ™?¡yZ§ÚXì¼’i•»I®QÌ¯n¾ëc<ž]ÑáÌ¿Ö©øiŒ§œ2ÈMf˜v:Ï›)ž-—)ŽÒ‹Ö*X¼Ê¬X>ÐHÒª¶I>ßŽ:`ðÒEíç†;u7âù¢™Z«ÍO:ÍOÕ'âëé)õ\’4‰©™l`ñ+»] íŠp/?mZ‚XÑ8­ì*‚pe!Uœé‰ÇW“Þ°,&r¸^‚‡§ã0çUÍ8Í›–=ŸˆýÇ%[Ö¦b­Œ`2¯NÝÉ*ÒI¾YØ9«f‚è%;¼<åÃ®»·S•}¤®CfScáhPÄxAì,ë’ñ¹ª>v¨óKE›;oºVÈ¯I5ž*i½1ˆç‚×`u©‹õq6+ó^õ±‹¯¯-¾ðûnž-4šé1<×ÕãzãÇæ:Y×;àÎè%J9ÃEÐ¥’þ3\<ôèonN¹ãoßŽu=9q”OÝÐÕgöñ‚&ÈŒYMEvclk<Ôköð…_¥7å™ôç›4Áq„p¨ixÂp{Áèråsž ÅwNõ}XÏÎ¶aÞ<½zÜso);©î”×ÀCÌŒ¶ >eNk®N¹T§äÙñê?p[~8§”°õO–è,¾kîíStWŠÖDG¦æzÂo¡bõ„ëÐÊƒÖ(ll†Ï›I+ÅkˆCylœ¥èùT¡ qŒzþÕÎñ¡qÍ=)¦ÉÚjˆ)µ	y7¥…âEZjJOì.G©è‰Tû”¶‡©}W;ß¡y°—ÖªÑQ/®&‚F`ºäÔ3´SC˜f] ¨(ò.ºù\°Ÿ¾¹‚îhjÀß@&X¯fE.¦€(½Úï5ÞŒè¾5:üÀUí;Sx_,'7ë3'Š¯W~§ž>…èmv]0±5âüX„Ë–P†µÛëˆë Ô(-Ì=ç;©ð¾W§A²—ôJ#ñ’z:M¯CÛZsgµ$›ô;³¢“‘5ºHd˜®ÿ%†+;|ÑêG¼€>ÒûÊgZìû©t/¶FªÈþ«¤I¤¦>yÄª?ÁëÐhÍszS«ô£­Þj°v	æNÅ~wŽÕÚ[ßÊgëY´¤ßÛp-ßˆ2†ÏàPc ÐŸ ¯nã€?‡fìxa \	uBóïëç>œsÕL3â…1V§G	Æï4dÐûŸ;ÿgÓQq…r¦Ù
`‹¼£ÀÕ³rÃÉ‡Ýý•ÝGm…;ZÍÏÈ§ÛHŠ2c`SgGX$)X?ÅzGRoÁ¡E¹tú¶TŸžÆ5ÁS»{Š­5´Îž[âWüÇuu$ÐÁ*,Sû÷¢šz4DÉä0ŸÒöRÓÙÍnžõô©<‹uÈ¬|¿žá¡E5£ø•',¬'Åcâ×’óÛ&.9UM-<3.8ï®ðC/9º-°ÊHÌ[“–ÛÛMÑËÀ\oðÃÓ?ô+£ÑYJyVôGJy]ŒãbB—Ô°™gxË'Oz5Ø2É'ÉóZ©EÒ5ÿ.y¯L«!Ý .t›žgdq ã€:ý»/Üà  F±ÔíÒgÌgÅp†Om_Nå&Ô_PÚa?!‹Ë½;u}6ƒÛì}ŒC5Æcù3ZCìÔbñìÔb¢YÄ²þ\6Žžççu‹¢sFü2ÎÂl9;)Óž»ÏaËÙLž-2H=
ÖsHŒv95@Ð¶¹æiÑ$òæDèÔƒUbxvyú¡Ú:õ²xxFóíÅ¯zØÏ¬°h’„—\	°&}/Z)à„;ky-,Œ…&:Tµ#BjÙ×†&pªaùÚ’ãE |Øéù”¤A6Ò’3"ðþã0)*r!Qëˆ9RÊtœaå*	§6¨4c'BnÇˆ,[k‡¸¼~ùD6±‡ŸøÎ;õj‹ií1’]Z´·=2Ìã!“F'Ìnª&	‡yÖ±­2æp\œeÍ”ÃÙð¨—e™ŸV»vDÆ›ª#å–õcôïQä³yl®ýYà8=fr­F¹&Õ5sÀÌi´ŽJ.Š|K1%EÀvkàË/sÕ:"	"U~·CE—ˆ°¸–ÐÙ$=£ÛA—k€Ã-îT&éÀu\älvnü&â3	Ü©|8IäK8m,¶I@§W¿"œå:pi~”ÍÒ|´ ìÉšJjŸmÏ¬»þ÷ù+‹ä°œ©mëUÈ•Â-n$çâ½8y!6[tík¹µ)NÎZãB_@’
	ò,ºsQC…&^­>8D¼L|kÜÛÄ4¢BÓÉ$Æ{MÝ“×õ@‹ÀãxM¦ü>¦ìàŒêLQÍÓªÿ;Îmtƒlž`TzŠQéz Þ]COÏ|Y…¦qZ®ÃÎi‰o"zþ÷Ïè%…"Ø—µv‹>H­y5TVœ~v:…'ÍŸmšD¨™?wrñXìBnÖ½c
ãÂ¿g
ùg‰Å2ed£ÂÆº91y±½Ò¶ÛÝ0âÅgŽL<AÌ™w®<ŸÒ2y1%8~Q§éÓAÉPù˜±¦3LÏ%ÖcúžâÓS×¨‚3zGDgl†Ó
šFŽj·õZðcjšðnû`Ï›Þ@vxd±"Cè÷€p‘ !Ï¹’…-äVÕ 9c™ç§&‡OÜSÄ¡@<ÊÎfu71ódøÙ,Êý2ìœ#s(¢…a }¹RhŠRe&‘ ’ŠrÑÍº®¿¾±ÊÞBµA‘A”Å¶U›C”ý)yÀ7ð*¿Óñ9àÔ®À—
gèÔ¼}šV3™ù>Vr )Þý3Ùb””‚‡Ï±´ÄuA!ÃIÑ M[ª¶ùÆÜïƒÏé¿4ð“ü"øŸÓ²ÿ#ÉïÝñ?W×VWoñ¿>Èïÿógý[€ÿù£ÉwÇÿ\»·~ïÿóCüð?ïmmnþúÞ-þçOþWÃÿüÑwÿkñ?ï¯ßßðßïß_]¿Ýÿ?Ä¯ÿ“¸ ös!´ÞÒ…ý)94Õ‘ý#ºÜ&ØöóXÍó?ûÓ¦R·èzPs!Ã ÍA¹»@,¤~Yä}ü'Çmms$ÙL\Cê˜šbÎú&Ók™NÎù?ÉŒâRºkz-ŠGeåÂÁ˜pÒ,ó36Ÿ4tÑ˜´Ñô¼çn ÄCéoè¾úâë8,çÍQEÇõ«%ñ¢o Õñ>¶£-	ÐX)&TC›æÿ„Oº“éÐÙúµ‡ÃCÞJDï‡iïÕyYÌ'd»µåâpbÕ«$XÌ­‡”Øæ8YÆ.ÂG>{å$€íäøäèù³'O¯RvÛôÃÅÄdˆŸWµDÐ´O%­|fP«h‰÷céäB–2¼†^Œ9þ•£üxŠè¾ºPÍé²ÅÅA¼<Lª^ŒÔ2„î8r2‚T2¤V<b# |)u¯œ3^)¥ïÖ8”âùÏd—yò’:Zö”É¢ïÆ©Wºä“ˆSÚõi1£è–O´Îæ£Q†‘‹@Èb@7>*­*ôÓÝWË,´Ö:ëÉ4-Óó2iÐRÕ4ø¶zx¥¬š´T—¡Dr‰AYt…’•cäçKÌ™Ë=K•L
JžLôÖÞ$HQ˜¦RgˆÂ&1Î‹.güûHÿš¥ÑÿýÕ^3Õ:H5ûÆ[	}²®%´Z¨KF_fÌ›ËiIq	óaJÙŽ—›\cdÒ¹QÿNúÌÎT8°†eì†æ&3>2œðjˆ^
jÚÆ3ÿ“ÄÍš¾ºnv¥5ÄT©4ÓFBÊ*¤å ŒsñyŠgr&Q™Ÿg–ÚÜåG°8)n“ŒSF{”¹OæŽQqRg—Ùæ©~CT!(uY3š’?<‚¥Ô6†Æ6úzä³v‚EùMœŒä)£ÙÙ¥€•‘MªÔ¡J{qùª@¥/$Oƒpû_ä£BVm×ÝîJ3]NSŽvYq¯c9åd+}ñ]ðXãZO|-7@c*ÚÔá1ãó£/Ø<p$Çr™lÓÖWÁP·‚úªmÕ+þ¥‹Ùð7^áˆ“€UÆì$´bŽË~Cù$ÏÇZË"W£À™'!M…T3{¿ì0]=8KX8ÌçÞ0ù/|þ7æY;ù*;ƒ?™;¿QM™-	 âŠ­&#n{w¢mÜôÎKôƒ€òØ2Èj×hü¦bsÂ¾)/×º6ní¾†+73ÖññçUòYoRž<Êh¯ò¢:…ýóT¦ûíÛ¿IZüT}eÙ«)äÝ¦hô>¤?©•tšKæiC+!‘ò@'{+Q—Uþ'à%¼1G„SFÆ9¥7Á5ïiÙ¿ÄÛ"Í™X{(/â8­\ù°®{o;ßu}5)où¦LˆÔ¡DÈê¨ÊÔé£Hàmˆ%Ãâ2¸éå½ÿ,sçVÝI½–­½(—ÆíÑªl³løÆ¹?7Ü³?)ŠsÞN®’–°Õ6Ü]ºZÜÄ¦§%BÖë®b#™}uªé4ð0›¥6ü =ÍáïXèAo†nû!iLê@
'ˆ_œglzô/{¡¾½è’« ÿ6žLÏ·Åyž5ønÓVX“Íþ†¾öY¯Lõ MƒƒÇ={RL:êQíƒµ»ÁáÉ6Ñ X?vß¨õšJ“Ö5™ÏŠÖW´AEä¯¡©ÇGñE¶‡þ?
hŒ«Ö ˆ°Mg¯S¼™+ðõ5Pã†\sú¹ôY°	BUÂÜä²w9$|/X—|¤ËÕŸ–L?´Y<>Z' ²¢³}3ÜâÐÏCä,Ìð¨uåc” éÓ×“7C½¹×M¸Ur–|¢E¿O×
ú&éØÔF?sZ™“Ùr½ÑMÝG£4Wó°Š1'õ€/‚ã$-ŽÌ¶‹”å±\¿<ƒB?
Ï<»	Ó4-Â8Ú¼c¼ Ä*p-=#&BÁ¬²Î03ÁV ç& Ü®±N4‰sÍµFµÚt?#öÁq/å¦ð œPkmuõà!3Žˆ<´´ŽŠ´Æ†Ïˆq’îUB¶câm’„ŒF~*e"Ílr¨²ñpï§å+2´Ê:!ì%BÆQºÃC18Ýq‡vŸOBSŸ8ß»3|<-E:¹ÔÚ¸òb?¹`Ðeàd
³­9Ê
H)©çÆøAà%l«*&Ýä1râk\VÐÑ.³‡ñ’m:+ùÊ¸G5T¡‹	hÇ_íî<Ivvì?à_öèã¡7!ÖÙ¦£_íY°’xR Á e©|1nwÐ,É}Ü6p€¦¨oJ6_PÃ?E+B??§sÄI1ï;Ñª×Nž€|D´Ç/²ôÎ/qÐ=ôVÎàPà«|s½8‡g³AÌÀœ¾ôßÇ´7”m%9yVåä.<Cvša>*ªb:t*a“çzqh+y!8ó×§®¹àœ`)ÄþÄì~µŠzÓQx°‘hëšú2ÍéÊ„Pv¬§4ƒ6èñ¦¡–,äUóÚ±óÚ@ê}µke›”fR‡YW6sI¤Üsãs îÅå61î€\àT)$ž0¨:šA½s~Ø|&¹{—8¹uuÀvPíR0EAŒ£]+éáé@Uü…^‡¦ò!Ûü‘ÆæWaZVá1'Ø¯q!ãs«”0…né9Ëj3y-šxÑ\«¾xY\:aˆÅ÷Õë>ïª?Íï>ÌaW·’’«Ÿ¤g+Ùd‚_"¼"0×ÜÃ¿ôœ \vÌŽÆÀ³5s'r
!R¿DßÛø|=Få.U†[º\EDíiÖcÃ™eQ!ä5	»¾µšíQ¾Ú00 ®CØ\Ý¡$i¸/$¶œ}«A“:†™¯†+Åc	/Ù&glsœS\†Š
(lÉ#hƒ
­|êqí>E†AòŽ~äX”–¡GÖÆ¤xp4Eb+Î[¢áôÙ´’¾ðF~ekÿ^´ óßï-l¯S]»”4‡˜8©ÌË€¡ÅtDe¾ì#PI¯NEUŒ
O¼º€ó²œ=~ÔT-¯0¿`·ò‚Þœú70îµír†á©õFÆø¢¹ØÌž•@`•úP^'ŸDBƒUFMšÆë©ã$¤ËhÜ> Ç“îCÍªôÅ&+('ÙéÃ~ÅOÜmOÇ žŸ¦¶\(’{µÈú¼«çâ»Å>£!:å3=|B_r“«iA×Z¾ê5³#†ëvßI«j>VÙüYuÞû;A¹è¹D²Z†Ç—aË¦ÍPè’^Ä‡”½aÖÙú9Dß5Èo[…Ì¶}@.?ïfg¡móÝ,ü_§x©§ˆý†k¡ë<´©2&Òùh†õç¯W>-vÛH†¯Qj½9¡˜ÖPkÊ€ã”ÞíŸ aN!8å¿{
}„e„Ùƒìç!×4yÐ\Ñ>ÿîiŽ·…0ÈÑNQ4FÝ›ë‚¸ÍTuêËÖßô}ÅcGû7LØï…Üßkj/Äþžh­¶_[3—”JÝÖ<d'ÚåL"íÜÞ\+h$'‘ëµ^ƒ¶ùÅW,¶XÃFÑ4d“Õ“‹q=—éË+¿‹±_§X®Aø{I´EùlØbYã“óÑîÑþÉþîÎÓäÑÞîþñþógxÁ™±X uÒÊºçÝv$OO›²-ãÿß•ueº±|…¡1‡¢ÁÎ‹¦Rô5†hðªÔoÄdrFì£šG¢AŒ¯9î0èì_róCø²™dc1Æ•µ+Ø«4ãkç!0lQ=”Ü
Ï.€¿R™ñt¡@P1ÌŠíUjÄ	E56û¶€û—$µ9SÒ¼~iRŸ> 5-ÇfR}C\ÄÏÑ(~ój,Rµ¨¶hÀ€8»ò©Ü\6(¨@›<Ó—bÍÀ0Z}yÐD|½ÁR—µcJ„ÓƒÔ1³æ#ë„ÂXe+?~ôe8bJf~J¯O«þ«&}Ú Þ`ºÕõS½X¤Ž}°O×vGÂRªm€6²¾zŒ"O(òìzÉ¢úÊê¢›ÑÁ¹-°_íØxþ0ok yÂ¢êº$Vß»“·-x3žö9TÔm³ŸÚ´šó[øz%¼6ÿ;“+ïú*¦ƒ«o{.¡äåãqcxjÐÐß×\í6y7ŸŒ¶ép³3rxk…þ]Y•%gèt›9ãÍ‚»áEþ•z”òÅpŽ<ž‹4iuäo†r‹aÇ,ìok‚Ð à±&Bìïäoÿ,WiªÒ?ZTë: ïÌ>wõ=òóºÖ¼R_¤ÁB[4ÆÝ¬ÞŽ	mŸ˜m¹1'~A­¶¸f-h@wüîY}ßð\‡!è»Rš¹Åäò²þÖdzÔà5ën¬L¹Œ¯É#¹x¥ŒI™½MÌ,u d½ô5QÛ|[hœ¾>5=ÅuUEÁÙS|ÞÊ*~ ² ï$¥Béja‹½=u€2—¸éýpôð¸Œb_ê,Ôñkeš´8,½7é•WÓ¸ÖœÙw¡xÂOdQ]z˜5(ë× ”»W‹öö‡Ö/¤¦ÿY—‘°~pë P^®#©‡ssÚÖQÕÍ8¸z¨žâyž´_1¹Þè¹§S~±ˆ@qxuù~ˆ²G¹'Çér-æz3QÐ×¶VKÄJQ9ôò†“ƒqÜmhÂ¸ú]ÛŒß
`ï­“¡i¡ÎEžÀÉ¦yÏùðø|³ï’§æ]T°r6Ì$M†ùù°3B#•ÇP÷øö¤âÀ
´¬]¤£.ûá[Œv˜úö~
ÝÄ0îà´"Ê,hÅTÄBv†`ÐSºgí™díiãàùÃý§{ÉÞáþnr¼÷»{Ïv÷Ÿ=ÙöKw˜kìYí"[5TwsâÂ’ù€!cÛ³ë:`¨6fH‡FÝÝèrr9äAÐðqXÆu(6z×·&ú1æ eËŒ’,ÙèUvÆ‡&v¶w'Û¼±¿Åâ¢zèN³EFà®>åTm×fMÉrì74ËÈ¨îQGhy³=ÊYïª7²i¦Úb¨TÔéá=g'ùˆgÛ¹Pºyý„orU
¾d¯‰dúý- áÔ|{Ý¿1¶Bå ·‰øÌ•ŒùJîéÂol4¹ráIŽÃn#NT0›âx!·¹eP6šðK›ÑÃÕ'Éadó%š4¬¸â&Âi4=4Ò±î»Fb­¯€	#’íÍ,uÊžŒoßš¿©¤ÈÛ2›Â'p)ž‰Çbf™+Fk’$a.©Ó/Ð¡JÒ'™]·Ñ°ÃŠóóp{˜•›„‡Dt»F Ÿ<?ú}rmÿhï`ïÙÉqM¦ËŒ¯áŒ[æßZÝLD:˜´Ô2GiG'0—#ÎøÞ¹ì£.ª¡µG\þ"_¬wÓñÓNÙD\ElY>p˜iˆ§»X®×Z7EJfÜG¹¥“ÖÄå`'Gåh ­£ø¸çèflÅ'öC0»–ã¢Ìi,	'£OÇÛ·7ˆx'¢6(ÇDð`­tZâjñð½zWß]­`íÀuèoüöm[ÚO.Q+pú¨ Lë2UÁ;œ»ñÎ&p‚s{×–
iR£‹c³NÀf1Jí8¦Ü–^à8¿ïõ½Y”ÂYÂÐy[[{ùoß~ä5ÓHqúFSðþN‰±åM´eã«‹‡¿àO»¡û»*9ÆL^«ñhh)Œ;Îµ­ð–kMéýÅoGù‚ë¤³¼Ï°¡©ÞÜsÀ"í.Nè7¢…[ö+ÐÏL$€YýZD$£¢Šp§.æX0å4æËaVZK]kë{ÎF†äMÛ€«DLZJ´òúÜrmkî³Þ+dþÐ|>Šš7vM™äˆËÈG}ÿ}˜!ÕPíBÇ{“‡·âBPOhSÌÝYäðè…óókVJI;‡QÐfLGâð«bÎ÷†S‡òPÎ'jŸ÷ìÐLäxÞcª¤`èÖˆ‚Ð †³iŒ’xl_^çzÍ·êˆ”>ž6Á£;¯úC¿˜GÜ'°8’ÛRÎDª 	yàGüú)C´wÎ €îfãÔó	ÌE÷šÝáÃÆqAùÞP#¶¸=bÍý±© Ä?ªÇ}202ÁšeìqçÂ(^Žç¯¨EÈV’‰Ê+½£¥<q–#jŽU0·Wé(Ì‘Mss‘Âf1·¤­Thì“~ H#ü¸¸I£.7™Óû],fBëµðC™Ð52á¿"®SøÂ~¯®a½Ÿ ¿µóÚ‰1Xæºaµh‚Ð×ºE¨º7H‰«fÊþ0ãäqIB ¢š‰ªgv8¬ôÝœ•¼\,=àè†ËïtÜéº7/J{@~O»±rQ_è	54ÂGOØƒëoŠêîiÔ£/øCaT®_<+·ÿbŒ¹n05¿ÛÙU8›¬ÈÀô-/z¯£>kÍš8£÷JÕ‰^MÄZ<<ØVjS€x%T¯§.S-yäÆˆ +fù „xeîeúÄöó8Ü¶ZÁÈž%RHçwX\H³ëV˜I¾á›1ÿ¥±ó~
¿î©MQòÞ¾¸[[ï€ÿ¼¶¹vëÿñƒünñŸÖ?‡úüþäÀµë?Ä^Ûº¿¾q‹ÿü!~qüçõÍµ{[¿ºÅþÉÿìª_yß¸nýãz	öÿÕXÿ[ï¯Kî÷3_ÿnþmþs4ÛòlÔïHž¬¿üÝó¬¯Ý»«ÿ}ß­þ÷³þ¹õ_Ëÿñ£ÉwÏÿ±qmëVÿû¿¸þ·ÿÙ¸w›ÿã§ÿsëÿ}íþ×­ÿux¶æÿ¹»ÿ˜ŸN‰¡®ê\°dR€<±¯LD¿ÆQWVÿ%3HÙÛÉçœÂÓ1›ïÒMå‚Uù”#wW’ßçtÆH2öK|…&¾O•6Âú³Í3hQ®¹b_uYàÀðô}ÝËcì;Ø8Ê-9ød›ŸI,.—è{s) V¤ç¹7¨&Ë°{2¾˜J„œ<€/Ì
lÞ<^Â[{‚(ÍÌ)oô¶dh6¦¾I¬¶ý4&‹I@BÄÙTù-™þŸbR—lvŠN†HVU ïI²YN *Óéi-·IÇÒ*|7)¨K™qf4ž®ÔE[A7köjÅBÄ[?6}oØÖ÷->$_r¼ór/yþâäðÅ	ºÃN¯8¡f0ÈˆWÅ¼4/06f°A÷pèNWð~,½MLà8¤¸yáRÞ$æF®y> Ó•Ÿ²g<dÛå/Ô.½Lº
»æ|äå:nÜ\=zMüššIçðÒÍ®Ud*W™–wìŠG»¼¯¯5c´6äzÉÕ\ÞmåBO¨'è?ÍÎêþ°Ò«¤šŸ£»„pBÙ	ê˜ïùÀ~ ¯&wf|K- ûv’(5M1¬¯M/±gF‡áob\£ÃµKœœ"#Ü‡EZ´¾IHå¦­s«‘ÒZìjH#âÜ ²rewNx“"áåèG×ìÝÒ¶ÞÍÎ	EÅ‘]ÇÇ!u$Ž'QïN‘9¬Í?›êy7x"Ä,Q²¤™)L"õ ys;j™pc¢b7Mzäöð=]ÌBòvrâ:Î‰š~ê“v0i!’ÐÊÆ¯L‹þÊ“löõr;ê1 ]J®g•` §!£ØÐÍÿ¿½/[ŽëH²|çWÜbÙTƒ]H€›(	6ÖªÄFA" H
FËº@^ )æåÊ¬_¦? ÇÆlþ­¾`>aÂ=<<Üc¹™ !P%UbÞØÃ#ÂÃÃÏqºšÕž(7À‘;éÆ„;“{Ã~s	¿3nÔÀÚg,“§ïìlêP†½üÔó—è´ƒ½Haï­ØYnÆq
gK©ªÆ®E'Ã¨e*h¹p/zè7Ž}w’ŒÇ°ÍQè‡öOæ
ƒ‡Ð<u‡=ÃÌ*6'01cüÅ;:‰k‡ìl@=wGã@ë‰Ré|NRJÒ;5{â
ÀžóI)	á±›õ|VQŠJ ÅÃsš»Ù‡!(û\i4äØÊŒÉÓ:î–f¦Ú-np,gƒ÷½Õ&©©ßÙAoCÀH áFp\ÎŽ;ïƒi¶Mk‹áËÎ®Û¹ÝucžmÚ6ÏÃV”Ô‘‘ênx/07_.bÙ”Ò%_Al+&`Ö·(là|orNŽ¾™‘Œæ	±Ê—*¸¢Šâ÷ ÄÛYê°ÃQpWÀóÌƒ‹Ò«›ð=èTÅçG»:«úmsËê g}wpd¦‘N€®ßÏÕøhá^ÜB©VýóÎpÐ·G#vÇ“vg°øÃži@»Òš;°õül(€†‘—ÑVä0ìXØsKßÉ„ h»•‰¼;‘0U%Ó¢]4µƒ´:}'c9ÉÚƒ¢Ó›ÄÆêšF)eÛg–Ý£ÀRã%„M]*þvxªo¤à-ÿœ‹EªÊ\^Î²IÙÅÐ'6gÃä,ÆPÖ_…€6:€-},g‹NË ù¢u.?JÉt«š˜©hÜ]ˆ†`2G½`2í|¹Y ¬H·€o)¢n¦d’˜©iÚI÷Î:G¹ÙuŽ‚ŠW¿@h­œÎ½M2"ÍmUï Îøž™ÂQ¯øçýwñï¶ñ‰¡Åø˜=Yš”Ü¨‰Æ$]|qNÂkPÆjµcµ`q´pÂ»®å.n%“põ‘mf1ÔYÜüÙ=”¤f1Ôm²³˜þî”~ãÇ^	7²µ&/t~n·wö7¶·šÏ–Š]±’€©E[D­)4°áÒ«™sº ¥°$V"©­¼Y]«s|Qí‰)ÎÏÈÍ”™UÄ«IPÚ´^ÙvNÌÁT±êËgir¹¹ZSnÅt¼ƒ¦g-·¦V«óÔ¢É´€k„Çó(ÛÑÉ\±DëH’àm)ò˜ówíhôMh3p?ØJ@3ÔZ3ú	—Ã·NC6Ç7]^îº0<VBÒõs™^LéÔ•æi†ÄÉ¥V³‚ØÏ½fJ.Q^m¿ášŠ¬à–àl¥RÛ.Ôê‘±%…Ê“UvÞÃm°si•Ü¢mFèhÜ•{V•çpÁg(Û1ò«õÊNI)ÆU/%/r¹s´c@ÿW!‚0\\ÇåÅˆ¶’{W[¼e»ÝFûsÉ>B.ÄêËëVfë4¨é´9Me'#)0w?ý±àŒvtäIY»ø›¶_btÙ"Œò.ßE|Õ0/öjîØTÜ¨Ú£ŸÏ%;Qä¬†m¥ÓŸ˜k¼xµÀï¹qØÅZ‚SI8æŒ~ S/:/þù¼yÏÅ3"âUO‘c@t‡yo_ÆâPA¯²ê˜™ q§‹:@‡á­xUVS¶+¦ãõq¸X±$ŠL‰î{Ã¢(ÒV—È1÷Ôª5{]lÜ•GíÕ¼/Azð÷GÂ]0O)„*G§T„0	Ä7)9GÉz<‰zóá(Ò‘æ(˜°ð›vgz¯Óñpàbhd¦	¹CTÂäDÉbYx>nª,yÍ®	*Pâ«…3Ô¨”ïÊË.Ü<†ÑŽN›q°œŽ0´Ò‰TÆU6Aì]ØŸ(`x•&Û„¬î5¹eîßáþZ/‚ÁŠÆ¥iÖ©Ôsp½ºy7}´èSÕþS¨f©ÇáSaW‡yò °:2©{dØ™ÙIK", ¯í9/ÃuÊFŽÎ[ŸÉJÎ2'u#Ì}Ã†‰pógFûSóÂ¢Å6}\-³OM®Å°¬=æ¦§´Ýøã=7Eÿûß{•éaÇ®	ÖPì¯úé;ØƒëÕÏ¡÷WxS4ÿQ,ÐÅ*~Võ‘…—1éÊß½±O¹‚)W]J¾žûGIqTøl«˜mÍeã·¼ìëÏº†Y×5¦W>ç:æ|êrŽÙšÕ}–§˜åÛKe<cë4œ^¤—ãIW¾…<^W£Å†A²NgÒæÚ|(¾;8,±¹Yš…ÙTä³m`¿ã‡ÿþþ20¨Šæ}ï›÷ì`·ÞÌú&ÈÍÛ<M•xû¤Ï‚&ùM?la÷FIK–/dÓnŒzK¶µŸpî\º}¯ª˜FôyÇ÷ùùAdXp×Ÿâ/îª÷&È	ýÞ=Ð+ º¼1ê«¡Ïþ[ç£qîâ¿÷.½"i«mÝómÝwUþ\rYIUgñ› ;4ø…©eÈ,J¢†}lÄ¢HŸ‹Ê¾)/½§›Aáîo‚ŒØþí%ÖºÏÿ~áß~„Œ¯.­ÙœµÑ®W>ëëƒP½[
åñ—ùã%R)íBû[ø#ÿûG_M³‰RK"¨
x¤‡Š–—ÂG€:}òfÓnÈËwø'³ï.ÀO¶Y‰¡:­oQá—ßDyŠ<ÞÝÝÜk³ÚD!ÓZ¢"Tãj\Y¾óÆµ¬Û<ë²–äku\Ë*«‹^|œo4¾0}X^6»_·»ôç¯ï¯­}}?øºI›««_­=	>nÕ}Ü®û¸[÷Ñ5h}}íñòÁÇ•ºku×ë>>åËOVŸ»÷×ž|µ|Ü¯ûøš>®®6ï¯®PGYÎä¢å´NÔK˜«ZãxÖxNeçIÁ÷@ÉŠ½#;ž¦CêÅêhpŸkXR££Šw$Š‡à2õ£ÕœŽ¨ƒsÖ- #BÊU}ÝÂJ_løVÙ JÜtáIòÝù˜;¾wØ%ÆÖYw4¶†W¢¬hYJÒžéTƒ‘¤»l.X’vìøK‹50òÀ¹µPì•@-9Ë"¾¿D®æ/]æíÕ‚¢IºÜ-X²4n ´V(p®µ Waðð²}¡ßú_» Jµ¢±•qh£&q+Pß›¶ìÄú«¿Íï5åº†,74"Ž»&íÍE-˜¼ÏŒ†výòMÈô>Ôœã‰ImÁ©að
òÝä®=µ)&N-!E&I¾À|‰–?Ù´Å˜/`è63µâP¡_0·k¤¯/çûÀîŒÉæ|c›ãêÃæ5ànÓëäÎUK<ÇZ¹5ëC¹8iPŠ=kôyG°uÑmžšÀu»2MGÉéè³½ôÓV'Ìö)ÍÕò•¦Mì²W­#,–mÂS—ÙKá¥Z>ò›Ÿl}Ê˜©õÛ…»¿®ÿ¿ÀšW]Òú“0 ÿ|üøÁ-þãFþnñŸè¿üçµíWÇ>Fü÷-þó×ÿËà?ïßÿê«'_Üâ?÷þóÚOÿiëÿñãÇ_†ëÿáÃGOnÏÿ›øËà?SRpÇ!@éZÀ=½/oIÖŠÁ»;ièŠ‚ott>…Æ ÅC	ìÈ6˜ª5!Ì¹S&%{ÚÐœzÀ7_ªþ)ì<PÆ|pñgäÚ±µÍ™m8àDE¾œp§\Þ,ÛÅf5>´=TwíÎTðg£O.6êG×úÂî»½E½p/Ðg 5'¸‹âš~Â{ã’jG«Ýás¬{µ¥—ìÃ^ÙnÌõ¨BVÇAèÓ®À^1^½÷µðÿŠÀ¤ˆH=ê–£sIÖø­¹ j|‘RñÁf0ã}
ß,Î†˜.)ÏöÏ¿àTÅó	<T*ÒýEÓÜ
árL"†Ò’À SÌŠwÕ¡üÑ¿¾>\(6FÖ R¢,
á”=ëJâ¥rÐ¯¾á!1¸û6Ž!Ð®î`ð)„Šì¾.<X“ƒhê¯ë÷ÊBa(Í&ÉKec]ºƒ“$>H‡²†ÃÝîã›î˜%1ë=[Ö„­ž¹·Ö^¶l¼VsgGÁÊã‘ùÖ^mìíol=U™—‡ƒwÙÌrÕË§ògÍýõíÝÍÖæÆÓÝ&øBÀÎvãŒ~Áà8Æ»"D0F¨(áåÚrk›²„äfÛ€ü$"ËI,jáŽ^†1n¤Ú¿¤K‰\²n5°9ƒà¾÷6-‘bnÐ-[=$4vÜ™ÞAÃÜrsÛlfïVŸ	á„yzc8ežh‡ÚÙ]»çû	g‘o÷–÷ÏL‹øûLÍñ¶w—-Q·‘o ÎT«Ò´ŒºQÕ&Gc<h8¿Ã‘®sÿÒcÖMñr{÷ûõgÛ/‹åÝæÖÊ·J4§ÊÆlÈìê}u4Wùb„„k™¥ïO&bêQváÅM”ÈÅx¨9gÖlHiB¶‰ë!q°ìØ/. ‰>[d„Ìâ¤„-Ä¹FReN|”a–¤7E«­ëÑ‚n,BŒÕyÙèýòñ‚6ˆFÕag±5Êñ°óžS}±Pì…ÊÎâ›ÿjëŸ,˜c™ü‹I;|ËLæôø(º!>V%H³uN« Ù¥Tv«;iñ¤]1 gàžièËÙ0á_l• e˜AÜjù"Y$C-Š;öPûÊi%9!œ‘PÆ”üøâýÓ`2ìWÒë+Ž,‘MH·³C£mžÂc½L@Qä „Å "MÿÃ{ÎÚÖËÖý°c4±cÔÕÑï¥>CH.:M
z’ÆECAÝ=ŒÝ‹˜òÚÇ¥+mZØÊ)áEJt6‡;û©K£ë¡ÿxçÏ	ª%\Èœ%%ä±> a4%žR¢ö”é#Þ·D0@©mr¸ÃBÍ :ABœ‰ny¼îÉJ¦„…¨ñ»ŒŽocR[det@;ívÖSºNišM:1Ó?ªVBQ‹7Å|"+Lî;^[ù)=–ËdºE'ªÙ•¼±Ê7ðw¦„úŸ’A—3yb¯L†x»Q˜8‡ÍiX\Å#qüš£ZÃd‚ÿñ‚—­rÒîøÂÍ‘Œ¡1+"pžH5 ]ŽSmür·ÞNÿÜ|‘ …¯ÀÞ9S§obWnžkJq{{¥œ´ÍÕ¤l÷Ê³;yÁu‹äŠ§8¤n	]?Ô•ý¾:›¼yñôe6\™5bIF0Ž-sä¹-£SB]üzòÚitü‘=™Ì+·wŸdÐÍçaõÀ¨°ø°îÅ¡«Ü¸žºSÖÄ¹_h“ýèä©lÛ]Á^¹^¼J·0ÒC0àÀþ0èÑ9’äFM}+å¹fÓ“§su>èN®|G!B"Î<ó=›XaÊZ‰ò‚çšPOÓÄãrxRcº?Wæ¬Ê¡¿¾šÛ
ÑîÑ–¶Î¸*‘ùé°lO¬´J LâÜ…î	¢cÙE>ªrz¥ÜRTÈq>Ë‹?×IGëÊöææö–?MW¶·ÌIû-?J¼¤[‡©Z‚Œ«Ý}]tfå)b~4[ì°#Ecí/dÚÞ*"1˜·âsÕÓ	k¦¡d|äi­J+=W—¼uáíCw¸Ó½`²CÙ	ÁÑ¥‰9Ð×,™ŠBÍÙ‘JMj}6úÕœàäÅlŽJ´Æ|ÀŸX– °Uæþ|”Øå [Šý-ß7•L³ÔÄÍÜ¿8«öð¥å¢j6l|¼(´šíÌYúª¦V€7·ÐÜB §”>Û ŒUKiÝ³€öiË`y(ºáËm`SköÊuj‹wýMÞÉãÙüžÐ6HºŒbáÂÀÖÝOFú„
.'ÝÎá°THí-ŠÖl/(sÍâ¨Á˜%ìëÙ oÅF»3Õ¤ªpwn¯Ò
6WV}Œ­ñ`ÐÕ"(ÞàöœØä–ˆµœv†íÆ™QI.TPöÀèÒ}ÄÖŠö*ËH$Ð÷S¤$z¥â¢jO]\”m6`…>†i=üSÂ´ŠHxpûOÊ¾^jö-ÇÜjúeÏb'Q•$mµ½â,¥B4#æÕ¨$‹Ä•ØšfÛçê^‘A×RéÌ$Üílª)§´Å}D¿+M»õ~=¦JMÌ#ÏõÏeƒ¨3gÎ8À¹ì©£ÍËLÌô~‘pnÒïàk4PV.òþ=/WÐ|Q=¬4¹“¸xÒidÃµB3o÷ÊÚCÝ]J!SÈì¢Ê°µtÈ
Ú¬Ö%œc?bo {›,ÄµCQ-œ¶M å-/Yð9-T,sòXM³êÌUmÂ9º0,;Ä	Á¶ôöc6óÅµ6Â¥T„E©¯|DžwLJÓê÷D"Bdhu´ìvÃââ½úÓÕºåõRP‡““û@mË•e…T,«ÔV!N[ƒþá „ð©'-qÕ˜íQ!(`-ŠÆ)g”–6ë‚æ„r>—‰ŠH=~©#½Ñ±rÅeŒÌýN©ŒvA
xxÍØÆ*wW¢øüœ6ÁÂT¹ì{éÖ<©ÙK«h4s£1šœáêŽ¤jã öõ8±…ÅÌzx²%óÏ AD,×ÃZCÃ§]-gÙH«RjtÌÆð¾F	Â<É’’¥ŠJäªüž”L‡HŸ'f3þdá¬J-JÅÉõ¾eÐ—Ó–E vr(‹nn Ïë‚{–Ìs‡]uè¯êÓ.D0®š¶rÿ1r>LLöÑé`€û'6EŸÉ}
Xí¾N9”™c#z››²/’®ž*«N´ë·°+ž¸®ÂY”z?ìŠˆtÎ:¹—.aJÜöÎÌöáQHÅ!•#ò.6¿`ôÔ›’IjÔÓ¤Hì’¼ÐéÌ±•£º—''Ì†C’–¸Rî$‰vìZ/`">h8¬¼z¨SBGN“š™6)j9Æ.:‰£‚²·ÄÙµ¼âYtJTjgÃUs°¼)§u'ð73‡3BC =qÅ¯ns•Ç Ü³o;G§ƒQÕÏûÊ¬oGö¹Tß(‘-Òê–Ë8Xw8ìRßÛIÂ©LšZÄÔ™B¢š{HNÔQb±¦˜“È“)…ÔDN0<ˆügB¼rG©ö)n0t*dèDø]»‚þK‹“	IöBóÏÿó¿ü“‘%ÒbR>46‹>\ñ!ƒè•ÜdXMÙ–½•=HíôA¶9ˆï oœÐó Ã~ ýâ#ö7Û
©Cz¤§Jú1ûÕag6è¢’©T×ø?vq&Àñ6ðªLÊÿû¿ÿû?‰oVùÃôi¤Ó»·½vpúd2æ‘GÏÏá˜ë¤FX”î|"é“€&Ð:Ò''Ã`I7›y¼GŒO—.ÝŽ„ GñÛ¯e91±¯íC±zÀK`=È30`‹ú°æ¼dkü34¿‘‰Ø¼\¿Ó}(Öü£].ßËêÐ8~(ž¼´N£Ô÷ý&î¯¥ªúö z,o~ B…S±Á)Õ
·O•‰ò-ŸÕwkâñŽ_ÅãJˆàé`ÍÝVf¬Æ’_=C—mÙ®6,›†ŸÐüàl¥“ÜžzµO3ñ|oSó¿ŸÿÞþÍÿáØ Ä¥Ú¾L¬‹—™ˆŠ…ÞŸWYy(žŠçFqô¶Ë åÄã¤ú)¾ØgŸœhžpOÝö{*y@ÕTìs3õî´À’6½P-`½;Õ­–åéÀíÀ*A@ÕT¼äFØ}ÞEM‰™·t//ëxvVëqjim6ê(f¾¯û¸UÇ\³þèSMíÞz—{9>õîëðGÛ]êü¥ê'Ž(_œÚÚâ2i°+{Ö2W½ž]­»¬p[ñµRi¥ÎŠ“•‘¨ÊzÆž$C{›åð~R†Bémñ.`>™çH’I³5ˆÝÎ€9Ê4,H)Ð4â,‹3s|8uú–Øûà¼‚SbÁd©¸›GÜ§ªù‘†oÏ$áÍ5-Ñà„Äà§ ÉN„|
lJ¨Ó#åûžôµŒº]‡.ÉöZâŽ(X„ˆPœNAë÷ŒºgŽ=õ¦$ÙÕpKÕŽ“ÇôÍ5Ÿ˜~òÃ£b¢1È \²ÝçÝ!ÀÖÝ“9€«‚h"fEä£1š€šP›De9i¾¿i8Bjð-aÕ°dÂ_'
‡–pþƒø1­£Éa˜Ö €ÑÜGÕ¢õá{¯‚£Þù\Ä™%'á‹›U»3ée3@`@•gµ[,î¡ÚŸÍîX0Òä}F½‹öÒžÊ‘öª2y§úø¸ðÿ†à5Ó²käêcjÄY¦Ý·WÖLðÊ¹¤6tÚcD–÷c³st€ËÉŽëIwpˆ^¦ÝSG	ûÝ°ýn€·PÃÇ´‚!2ùÝ#;¾¾ÒA	¨g˜ß¶ÄÐäË›:pGÉ¡“Ø| Rg}_Ø Š6+ç:¤ç?Æ]J ÐofDFhYáª| ü‰.lü*÷c•>ëâï§ªÔ{)6-GôIyJ‘ÆVN±yˆ:¥_B¢Ãyû†H4Õ\q7KÀ§´" 
ãàÇÎåTl^5´T\^Ê¬¿ü"Ç¦0_ÿŒÑø¤>Åiv¬íÏŽQ d8Bd¸psöÐ 	Ë‹3X>)S%ìZJ©ã~-vŽÓM¨NÙçøýe`ƒÄËF\KøÐúÇ‹ ¯þ^Æ½:ªw$IõS^HâYq{‹ïÊm œ¤Èí*,y<hÎ8¼É{‘J"¬Ò- X/P{1yùfpl'RL¨©	‘°!»\?B“éÂx»CFBØx¬R¢–Jµc¿ ªpr
]m%ôÉ½•MÞI¼/ÕSÎ¯Å•Ëž5ÕÓØØ'sî.ÊÇ™»éÿö&½^9¼ˆ7‰_KÀšjÌ0)eÏNDiNus<þòKÁÏ`žNuŸ@ì³=Øº[zN‚7yŒbƒ±òèFãñèOH,2AŸ°–‚f‡Lr‹æ?¥uøå=>““ÓîE±Lñ`G’ß””ô‘y¶Ý‹Ä¹ø\¹w§ÖäÙ©üÔ‰®E³/`ãK\©ŸüéhUa”ºU¦Kr]+K$Ï<`©åúãIÿÈb®Ãº'KW™°,ØÞË·Õ)’~¶8›€å”ÍÔJ¨G ÛªîE¨Ôœ.|X²ÃY§RXIâùñF–KØªé0WRo³RÍ>•$.vjN†`v˜œ™›éçæmº®¿ÿg‚ká×äÿJò>¼ÿå-ÿ×üÝòþ¡ÿjø?¯m¸:ÿç£/}qËÿyiþÏG=~øÕã[þÏßý_Äÿyí§ÿ´õÿèá“_†çÿýûoÏÿ›øËðÆRp'`ÿLx»ü%°4x£é$ Šõ“*zD
-‘ˆgÂO8XÚœŸ²ö^šÊ“-ÑþÀÝƒè•A åƒ£Ì{·ËºKJ£WÚj
ó'ý ŸüèG²úûT½s÷_?`ûÛŒ”Ÿ6 5½âlð*ÊzáÝjgYÒO9’	F˜„6‘ŠcË¥ÙÑ´‘ÚÀ;wÂÝÒS~-g;d¦H™þeš@O¤ˆ)1\ÃÇOK4úsL4ÚøTzÐ†âqªÉƒGS×Ãµh)‘E¼ê\"è}Ì]ÞàdPvGQzÓfLNäcy«>œ pñíÃ-§½Å–ò¤œExÇHäí­íXŒøœ"j8Îåª,5Bù;àñ¾2[	'w_Wg,QÝò1)Ç©‘¯!…F]löÛÃAGÉð†ÀµeŠÜ3û•{º“6‘dS„\r[)7Ú#Â¡y1,QAåø9ÑC–5ŒÍ¿76,oaÍL5±EÁŽ­¦ˆÞ@Š§Zé¿+ÏKK¼°(8Ì!³Z;a&òèˆ·¦§‹Šß!Y6Y‹XT2…{WÇ7×#c®ÍËO$Dó˜ƒé¸K¢ÓøÌj‰3ëÓXÃ’EF+T4têâcèOÍ´ù êò®At“ä‰ã›Þo–>uqÒ²xF2œ¹‚ùäêô‡¥x}•‘ä’fú0	õÌ1€í›!×5$¥X¬yöC~¨ó´f-Ez50v¦–‘ë›¦V:bÞXßÊé;M—Q¬& 7k\‰)C>ØFKSÿÞYUµ3‚¹;«`®‡Üà´[ðÞb¶Äsµép(>!4ê”ëõ€³àÂ(ükGàÎHü†dñI^l,¾xeö?£ÃDíð+ñ¹`Ç‡1ä²ÙÓ¢›d¢Mn9kK)ãIþ×±‰eL·©FÀv¬{•`IÓäjð–Uç‚þvÐit©Ónã.Eä¶79CÃ²]5ÇÇ#Úu”šàÓíj7ËœÄŒ_²@§O‚cTÄêJòÊ r»µ©|¿>éP‹J“›ibþsSÊ“6|)ít:óp¬ìØöÆ·Ûœ~
Î×G¼hR|‘Ä†Š7ñMŒ‘nÔÜñµ}|lŸÓ‹Wn`Y±ÁÙ>.{&{‰GÑS¦üZ{Xj4é³LevÚg^û’ìRó¬3Ëé\~6XY\Ñb.íÉ8º§–£u-æ"¿P•îi5~UÌÕ¹ƒªä´O‹¹ØT$T}Sºq¾ƒ»à®‰”ogìãÖK³˜«wÒi.tÎD(þ\Â7óž<í QGX:…oÒÁ“ëØ&E3§n7¶‰3Š\>VÐ³Ñ…8 ²òn:ìN*ô™ÂèlùÌb2æ:¯LiòXà¥ uŽj‰H˜“qp£Êº{"!Œ’ˆ,aäÇL°¹Zé2£íh†ÙKò!¤H?æ²Æ_«0ÿ¢¼T'fyóõûÛÒGP=†[ˆ+C:Iç)=QäÑ m¥À9	acsü(¼žÈø.Ù§jLáÀ‹»±-O•)uSŸ§‘G|*Kc	£œ›kå`T7¥O§]¼*Û¢%Ën9¦í”åèªj‹H	Ñ[_¾§ð^¨ªTõôs‡oDË°f¨òTg§åÈ-H šúñu¸Žö*¼ÓÚbÇù­
Œ©R[FŸ8ìB§4HþýÎF¬³ÛâŠŸF£>¬Ìe¯=œßÂ
ÓüSWÝP¦M³Ô—]²µ—dl{`†² Ùt÷S[—_ NÏQà'=˜Þ”xâTþâ«|3¥ànœ˜lçW«ö¡÷cœl+Öÿ±4[yå“8ÌÀ<Â¼¼ù¸L5Q•fà©ñâÿÓ4êŠ‰XÙÄjä$¦òpD‘òd^œ
Â%Ñ¦ñ¶sôvp|l_q:ÃÑ8bÎ¸s3\ê©6OX‰ótT
ÈòÔ=Ï…”>ªÞÌìR
Y_–aâ©ehò¢ð)->ü©¿CÿæÿxJ\Þ]xEÈŠ[í+X\…uvmyYÎ‡ï.¥%—d[LÀw–&dð¡øþ€7A[{IÈ±äz]>Ï|«vÕ¾”h’%’Ø¼¼2ª¶h’K| µûC±uà,!t!1N6¯Ô¹?Ûê?C)ü[ÄOåÉu”°üqIŽ»"éyRO_¡h:h“J1XŒ)ª	Gd±¡’]{ÔÅ{â€ÚÅ£:1HÄMpÙ$7w1•?°l½<€ü£*91è/mA^”°W)Î'ÊYÊ‹Wu”Ïê(/¶ê(/¶ë>îÔ}|óa„ü¤â1Ù*ö´srÚù­	àuaÃsÚ³Ÿšs@5ÿÄÞ~‹K`Ô…“.ÄQ°\n-ŠŽs°ìò}§7éÙ;¥C«wì‰{ƒÍ1Ñ<È’’.
ãé,á¥ ÓÒ·OÑFäO&¥G÷ŸPåhLîo«ò\?B"Œæ)¦4§íðnÊ®€î Ò‚g ‘žÎ›Ÿ†zÁ{" f¬cëhl;öŸÊóÒ:ˆµü£=õÖèî ›Šé]Ý¿ÈÀ#x2ÂsW#'m…ïªÃ%A/`÷«À_Æ&¡2=>é¹’ÆðŠÕÂW,	êaycR4ÉÔ@7Æ‚›2WPMµÌ	Ð*;Ã–}y…r€­`g2:mX1¦èœŠÂ¬±àq5Œ/ @±É¾^Ž¬+º.•Ã·:êøñ¿c—H`'FŸVƒ×¿ó ÿVˆ‡ƒ%\'âƒÑ–ŒO*ñÉ¨ßíÎ‘vj«Ü8;KŽOZ<F2—A¦=´è¶‚æ¨Øx¿9®†Aà7*+(Å¶ø~ìŸ&ƒÞ"[B¦9 Ú&‰#xÄMV2²Ï]˜5ÙHVï²daW}#K C¨IR2C¾uâK—ŒõKF¹žÈ3«©¢I¿C8<ÒdÓùNè—µ¯V³,Ì&BmÇá½T”ísØVäHô:ív·zWD2!A¡EcíÈjÅHè€š¹Ã	„¦§%1ê•]ŸYRAÌ4QL¤ÞÁ )8wd[Ü3Ý’šÙXðÏ4¥vz±½$&áûÊeo<.þ^§î!çë z>wPrâÑSŠbC<ÜàVisÇ7WL,ŽcÙÆ +Ü½<V>BÊÔËN±d¬†'ó³ºòó`Èì‚Ì/¼^Ì€Ïö1à=Q*ìÞ‘¥×¥XŸ~po°EšdØ1Vqà‡_~Y¼¼ì•ïÝ¿8³Ràƒô‘]SýÌ=‡†ï”(ÿ¶ºh?§¸Ìèë¸ÂIIV&IÂó-K$ ›ðå¥%²Ü»Îé¥‚HÜ¯ag·žßéA˜­§&¼&$jÀ|õèï3†_’"Ngƒ€‡Ç»O“YXÊ9 X_ØnÝ×¨‚,qÃtº1YD¼šˆø‘?7!³ñ-¤aý9™Hƒú§u Ç·`ß@›ñc%þ_Hô@VR?º©ÇV†¡kÂ‡gøêé	ÄÌßg¢¾¢WÏæKÿ‡Æy¼ÉèK0õ„b„¦Lñjm›e%ãE2<6Hy`Ï½ùéOM»	#Üä¡çX"‘¤™ÔöÙ:*á$3=Ø^óU8¢d¨ãúúþÿø«5ŒGVlÚ“ÐÜÚÆ µMÎsõÅW‹îËQeã‡3a¥Ó/u0nÃè…"RJi¶Ç}\iUÇÎ{Iˆ:q·ôÊ¶yËý:R›©ëv“ :)™óÖ t‘£Ú·QåQœ–˜A’ÅŸ\™ˆ¦CÓƒRÕþlø/ÿ÷š†|PÿxàÕñÿL†[üßüÝâÿÿÐ5øÿkÛ®ŽÿüäÁÃ[üÿMüeðÿ÷¿zøèá·øÿßý_„ÿ¿öÓ*þÿþ£Gáúøäñ-ÿÏüeðÿ)¸ãH ¿¸²!	ŸñÔz'Í Ð¿$ü?„˜þ©†JõHir¶qé}x¨í}ÒÅ¶÷%#qtîóª™Ò—lºžÍÛ‹:¨ëvÈ-¸ÒyìêåÙ ühÞñÆ«¥"ÙaC°â
pÔ ö÷ˆTÇ@cÖÂ›Dt8ìTÇÞÈò-—Ýz(I_+¢1µoT-pÈ‚	àoîüæj¤ÈÕE
6ÉßÈñè®<çêÏ—dl"CM# xl‚z¿=:*ÏŒ˜ùƒ›¯4Ï‹™.&¹ì°:-Ï;ƒáB±×üa­Ø~±¿óbß\ðgÎvÈ%ÁìñÃ¿à’8Z,Žñz¹p÷ŽïÐCG\…yä·— ÌÇd¤³6Ææ2›õ¨¹T¼ vvW­@­CÙ™÷+ËaÞÕ eŒŽùñÓÑ,?nðrÞÒ	®öóÒ±ÝGCšp7f?Øl•&‰0wÌ,¢û¾Y^£ÉÉ	x§T½$+ÂÒc]AgÔÿ·13¢ OŠbÈÈä}Ã¾d¤ÊÚGöå:%_©Á˜ºØaÉ¤–z)#I×®t‚É(WÖPnÕö-÷c4ùÒc¼5›EÀXµmÄ–DßU­Äøm_ÑrZáê>M˜ÃÑ½&±'1±5å³›šMñ{FÔf¢\¿Å®’
õ˜¤lÝ	™†æD)¯+”í¬¡g‘YÖúˆÉÞvæ*m‘g‹„"»'·@/kA4]fÂØ¼'2#¢ÈHŒûøîGË>-Yn­÷ÚˆU49 –Ê‰ø	7ÁÜöËæÞŽÓ÷gÅƒûfÜ¨>KÂ½ËÑƒSÇ3ìê§žËìÂ£¬9ä©ÇŸ{WL¼RkƒÎ‰QËTÐ²Á[B½gãØgqçÊÈÑ8Ûp¼„òX¶i™ø­ˆÎ|ëºçD¹Ÿ
Nt8×¸>w§¥é[·ËŒöÃqlá£Ôö"AEG§ÕÑÛn‡•Ðø6¥2›YàG±˜(þŒù¬n¢ ³G7%fg-xlì_pÍÑ8œ—ÃÎ`2
ÇäiwK3]mö=Š¥álÐâhÙ Fñüïl£ÏÅˆ¢Í›6éA¿6À”œ—žîeßÚßsm›Öc˜bµ™«(½!Ì ÏÉV:}Á5B¨éS±ÛÐs×Gã²ÚpÄãÁïnøü[ôÏÞ«‹Òß0d«%‡w•l™®(˜‚‘öŸ#½0ƒà¨oÝÉDNå¶¢”zG ‚õ»‚¨<:„¤SPp"Í;ô|Qî%”#ÚŸÛ¬ÆÃù/ç†Ú9;ƒÿ‹¢†u¶÷PŽˆ*©e‰Áåv	F¿ž–f«£M"Z‚T•L#cS›M«Ówò—“º=(:½Ÿ OŒ›¾mT|ŠæÄ¸†É›ºTüíl »ißLü[þÙ.¯œ>Fe./Áô¤ì.«ÃòÄæl˜œÅÊúk¢Pc°ûKX‘Ó†‚ä‹.à.ÿ(…Ñ­}z¦q·>l6Z«˜ÌQaÈ‘³Ã¬.ßR:HÝLŸ™2€Îm0l™}êÒTg£Üì’ÊD98º8êª½do“lSs@7¸bòž™ÂQ¯øçýwñï¶ñ‰¡í<«'«°a_hÔDãí†Eö©èlfoÆ€sd¡ _Yu€©eI¸Èà=þ®‘™ãñ]Ü@&áê#óÎb¨ÞxZÐíxì¡$5‹¡”Åôww[P¨âðÃä»Ü1gò&èçv{gc{«ùl‰"gV24^Í4J¯fNÆnÀ’´Òé¢ˆR~0u|Qè‰ÊÁÿ^X•kä¦ËL®oÓH1ùHë¡¹°÷¬/ë7¹ðTŠ ŒñØgœÄÜ[­ÎSk(Ó\®"°ƒt;X¸ùÃX°>èÂC†Î$º,#ÀRæÖ¡åÏŒ®ekÍRkÝx³¾u¶9Æét·xÛ»›ôÄý\¦WXÍd„Kíêó6kŽär¬Ye4ÑÏ›5óüs‰âl»Ùˆ×]Êö>ñÄ]V*ï…ÚBïÆØVCåIAé¼‡k&¸e“Î\´ÍX»²uÏªò¬NÿFÀ¬dÂ…›¹—’!¹¤A3Ã­auÐ¯
±S^ŒhÏ¹wµNáãÜŽüsÙ:6×ÍCOúpe1Û­/´[™~ÒÇž›³Wö4’sÿð‚ Îh‡Hž«µ{CÓvN±¶~ã½Ë—_?Ì½ø;¿2em2A®¢Ö\Œ‚ÓéOª(B“„Éí„w0yeZ‚ƒÊ/æŒJB F@üóyó¶Ô—B×ÃoYááÂ.o²Þ ÅVv+Ô13KãN+¤º@[ †£!`XMÙÌP{wX§ñ6ûÈ©ÞA¢Èlé¾7ì=!mq‰Zöãª[]ZÜeØKwþ>¼?éÂ_˜ÖMµ`Ñ·¨VÈ5oô¾rtJE„‡øª$'*Y€ú¹	ÀïGoƒvY"ßƒÀT†÷îiw-¡/›5×>Ø‚EÛÃ¹‚„•09[²X– ›¯æñ˜/Évaxï`©y‘-H¥|Wz`
ÜX†ÑO{s°¦Ž ¬Wž(&)ºFšºÃPY	2s Z‹âRe*†Ê£üáŸ0‹#sþ™iE¸|K©=%«öŸ8ëf‚CÜ±=Ê„“òxÆ‰GÐ¾¡Zî+t@LŸàRÍ;\éN·¼P|q9b-K&†‡»Æªž&|WÃh`ç2'"¯ò5àÌèñcjf¬8&¹TÃR!h˜{£ìÝ©În…°€cÔ™.áJn©4áË'sG(ðÎŽ@‚nvñÓpDqÀ—¿Àš0;«.%Ûü›ª8x|6Kê°æ²ñ+döÝ1¤{XOÔ˜6˜ùœDár:ÃÿR>ø,Dq©\ôÙ’g!Ýþþ[¡ß#H–ôÌ@~Ë¨ýïÎKl—&l¶UùlD7ÁÿFŠˆâûËÀî+š÷½$‘Ø­·TØ¼Íƒ¤	—‡Oÿ,h—ßhðÃöq”´§ùB,ÄöÁ¨çìEJ}Š .Ý®weL#:¾ã;þü 2o¸ûVñwÃ|ä„Îïèµu¼¹»[aÃˆZÂo
–8âÒ«¥¶VÑÌ=ßÌ}WÛÏ%7ÏÔ¡Ïó€h›ùâÙDhû…ïm„T‹'p<…R"ˆ ^&úL—Â]1Þ±ü›e™Øç¿ð…o?BÆW—{_!F´ë•Ïúú Ô—B)|Åeþx¹¿ÒPD±¯±…?ò¿ôÕ4›(«$xª€7Az¨hyù ù83g4›vC^¾#÷ÝøéÁÁ6kCT1aøÝ‹ø›(ÏC‘Ç»L©xÎj…Lk‰ŠP¿Œ«q9d5ú.×²nó¬ËZŒüªwà¸&—KÖ½qøÊ8Ÿ%JX^®c Ùœ…$ùq»îãnÝÇå:z’•ºku×ë>>åËOV%Êúýµ'_­÷ë>¾ŽÉTüG#ÏQÖjåD=ÎUðŒ“‘À'.;/O’"Š¨¤Ãg€66ˆ„‘ßœvÐrÌë<+Â›-  á\ž×c,(ìŽDñÚN¨ÅœÓ/ïá­Úlíƒá¸dÛ±¹ˆ„TË¶±Ž›ZÍtÜw2 ~:ï`´éGyF‘µ¯Ý£xÕ-{%š]ÀÈ‰ïC‘wc§¯¼(æíâà;ð*\°Œ&Ü@'ö­µƒÓ2vDÜ	ƒ†*õ‹ZÅºVÏ5ŽÛƒ‚û~I­Í¼ô”‹Æ{¢Z0w!¤xŒ†H;¬Q3C#58Ú»Mp¤Ç!Ô³ãyÊúD¥ÄëÔwó¾TShðÔ&R€Fþ
'æÙ¶Å}ƒ¦ |ó}O¡³‡T<wPîÜºeÎds¾±ÍqõasK6º·s€%¿4ñŽlbgKÏ
'êBÀ7)Î,<.`vS„,¶1Ü
Wºé2™¤ÒZþlN
4c6¸5uJ|µÌ¥½G ”W·T¾Pl“ŸÝ¥‹‡WfV­0/ünâsÿÚ	ü¯‘× ‘ÏÿûÁ“[üÏüÝâÿÐ5øßkÛ¦®ÿûaüßG_~q‹ÿ½‘¿‡_§ð¿=xøõ×·ðßßÿ_„ÿ½öÓzüïûãøßîßžÿ7ñ—ÁÿÆRpÇA=+8ã×è^
ok>Øò™Q¿>ö15vE{K‡þ¢= "(3ì.‚ös]mÌ½™ÓÞ>â,ß–ðÄ8Š«’fTËi[WÒÞã½~xîH@¯ª$–×…¸¡f7ÊvÛG}ñŸ‡•e	r”þ‹êaðM¸4ä³j> ¸{¨÷3Ö:ê–£Q&,¸³§ŒÍqÁoï"Ø¶^è;‘S©ƒw«ÁdŒWA|µ9ë)RA)Ÿ]ä[Ö—Â¹ÿY<.N“áèºÛ€sv,àÖb½ÓÐ©Z–Úos.ÄëÜƒÆ#÷ð2CÁèŽ€ÎÚ2îfùÓ`˜êû\oÒwÎÈ*`¿kœ˜F¹¿¿5MU`â\‰6:Zˆ‡ÖÜ#>š¯oD”rë"wÜy?oþázï¤WXYô°²k%Aÿ$o2(Ù•òÆ‘(1„Iâæ Þ¤p,A{LÈ¼SRŠB"¼ˆ[:ŸK¾Õ²ín‹”‘‘\Ã©ÞÀ| LfÄ×ËÃ˜, ô¯ØKô}Ñžêw}÷zÂ-¦æzú'üçÝs {åj2	kÂõŒÖFºKÖ'î
R+Þ”4K®]Kf7h»="MS­UëE#@Cë·ï°2ÿ»ˆ§#RMð\)ªhò¼¹#gÄ% ò†FP•ô¯ÊŒÐžæv[ÍT—:ñ”5ùˆ‚¥»ôZ‹\s=Id¥çyîl’I£˜‹Yç1œe4¢ˆîÑë`ÒMZ´à]§}R)k¦v–9(ÂÊ…ˆ
Þ®mT&å¡4@|ˆ}Ä$vbnÀb¼T.p>–ô¡ŽÓÁ»|×Èl&¦xÁ ~,¢Êâ~v… yï1v‹E¤ÄNôs@Ù×¨wcQÆµPDdV²„ØÇÍ¬‘÷œîÒ9Ö]ro)Z¼¸òó zi#ÌMÆ¦Àì ×¨?1´¥°úw\cä·ëhEñêD…ƒ<Lƒ˜IA®nû8jÅâYyô¶Ðñl…dvy¶b^ÚÅ.4ç3ZÌHòæ¡†cïmç”Õy|T3,Ôsr9KÊ:iK	gÈ–\©Û[Ï^[8¿¸Q%µ»ÏÃmÀaÍ8°=*¬ÈÕÑø\ÎNNtÔMÃð‚='¾Ç^ÇW´î.kÎ;|7ÊœUûè‘,À½æ7~¥–qH~‹ˆ{Öl…„EES x©ûÕÐô)Zª§DWÀÖSo
b‹þãà£yÓJá4yç*é–¹ð Õ¿5íÖÁ¦å½®7q™Ýx%‚Ns°ùPp³Ý»ÅG‘3ÊAç|i“+[sÂ3N€´Ëó²Ó-»¹È¯½î¦$D,f°¾¿&ÛÍZ({ªäd\–-+ŸŽÎV³_è2¸l’™!Ù!jîó@´gYõ³|3óøë"³s“å@Ø±µ#eˆ†{FöZv ÷N
å¥¬¬×ÖNÏMfõ]i[èìì6g•š ¤ñT«)Ôö9¬Em²/€.´r**òl˜í›a»I«AaÏ0¯¿i 6ëó×½æ#ëÊàk¹UNG_ÊÊuÂ¯c©·Ï—á^wl¦À.W¹Ý öÚJ^|òµ\|4\u_z!rÀìî¾<„ô´+-Áí6c¡9=BYÐ!>º§"®=¼Š2r	w‡¶žr“zs=|ÚÏ3â§UÁ× f[îtµJ_ãc­ŒöliNK¿°’G'ã¨gMóøÈwëPÓ	‹öPÓÒþ‘¨i„múù) Îü$ÌÑþ ÌªRW=&›@¨š-—¬Á0Ö.vÓÏ…mv}ôŽ&¬¹Æë B8_
—”b¯ó‰	ô{3‚ûÈ‡ /l<âùÌ»vÈ›f€µEÀ3èžÝÕ?xðs¦XeaÖ/@´ùCzÂKDì&öÖêƒƒýg‚óo#ƒ0]s9Êö»B7ÿDEðÚÃÉáD‹ÁÖ®\ºÞÂƒe
Ìú
`ð,ÞzÖúûK•Ð65MA¬#´9ë š‹ …µöøé,žÚ¾7/ÓÆHÑ¨Mß¨­£1ë„o‚tPûö@Ú‰–([¢·•úà«‹ç—V€¿K´û¹]}d9ò0 cGV¢ yýE‰VÁ‡bÏMHÆ,”_ÚÞwèrW&&Bà¶@9ïûq‚ËsC±Ï£ÿC-Ôœ²ûŒ/,²;n=²‹—uó—¾¥¯ó´OÊ› ;´ùµÅ®!|»ø‘—øF(¥x Î¹=äzökpXõ+þáµ¯`'ør6—/IAd.Ñºæ²hÞJn×7a,yÕP}Þ´,MqÞ­ŠŠÖpº^gè”kZ?p‰åñ–@ Ûý¼¹‚¨›ëu j81¦|X÷}•>~õåÊÚÚr˜¹îãÓ:ÌóFÝÇgu€èZl÷NÝÇê>¾¨ƒR¿ªûØ\©Z¯]Ð:çéçLOF‰ÛæÖú¯¾õ6R–;ÿÎ‹—TuLÿ8œz
­>ÆLc\LoóQ‰Ú„T·é”b„\ôªÞ¡}ˆ!ßHÐ›ƒçØ,tÚÝ)´g!_+üU"åã2Á#*Ë›	8 s\×ËËÎ±sLÄCá—_–däbŠ@0õIc6‡BU)ºÒ¥jåh½Î¡OÝüêÂ­ª
ë—&úŽÕX›wî(é‡¹âÙ‚ÕÔ8%×á~ÃQÞÛÓ"Ò¯¤Ûdàtú)ÖùÌ…u¾¼$'åk–Ê}–š(Âû/šú‘úM¿·àwÎ ïªãÓÊü¯ë-˜ç:}ô¶%§ÿ'ÅgÏ(?Ô›ÏäÖOþe?ñÔºP„Ó”ÜL|8\èâE5Zìôª1¿‹žpµÊúùLÜ~²$£-Sºx¨n©ØLi§Ý‚fxR€”Ü¦±ó‘ø~
zÞ­ÃúŒ¿¦©ÅžŠ`Ò[e!²FÂÉ× G@,Ýf‚öJ¢Ô)ÙªŠ«ŒTûüZ‹3«_Àà‹Ñ¶ìÁ6t Òåã3RxÙˆ·¹¸à¥YqòhSù8&!:)Ø¼´dñ¶™½eÉkkx@‰[rÚU7 øÜ0¥Û¿_é¯ÿÿÙâ?xðèÿw#·øÿ?ôßløÿ›ÿýøÁ-þÿ&þÒñ¿~ñÅã‡Ü üîÿêðÿ7ÿûÑ—¾ñÿ_>xx{þßÄßtü2þ· ÈÅÿ¾.&€©‘À¯™ Œ.ù‰œ ³ùV¡»3ì *ML >§xT‚[²€[² ú›F-‡[Æ€gÐ£¿;Ú€T<‹ßw€Žz}má’¼#'èæX²e•€Êt}|u¾  ÜEsgãú˜8Nüo’LÀg\Ÿ¼BpÕÑW}âi?+û€’’k¢ È“ß0¤ßAnoŒ‘@5àsÓ¬ðÎqufoº×qMj Ù–ÿ•™ò«g&zƒü.ð¯Âq à³h>òëd;è»›~{bîå¿Eš­ŽßrÜrÜrÌÈu 7¯l`jg§º*ë>¦Q¨ÔuüÑõIôuÝL‰ž]•AñY9ÔtÖ#Ì&au©>EB<]ñuõzã×ÿ6ÈfÜ6®=3Á7Õ>RÞ³ïÓX`OW‡w§ÕŸKÌrŽ¦ì_€p¡fj“KûêR0CŽ›ç_¨ßW?	Ã²Î;êü#¢÷·ÇÑ f·†¨aV)øM³5èkÉuP6èõÊ¼Ñ®=¼!¥iÝ$ƒƒªÿ–Æá£iô8þÖ¹¢‹@=¡ƒÒfduˆ«¸jm(ŸÎï§ÿµHÒÇ×•˜ô˜]‘î!÷„ð¯Çù z?ÈCYÙª'ô5‘DÀj³!MïC1ï¬iÞ‹‡èóQJ¨!üMñJûŸ@)¡3›Dö)w*¥„Ê9;¯„ÊvÝäªðß)Ã„V”þx4±¢x\Z²®‘pBüi¬u#3+õ„,ãFø'j<œjH(RŽC	&
•ì£è(tóþPœªë3S¨·ì·ìE†¢Öµt&ŠŠw“y*²o¹³“Uè§ðOd¬H½«sþ¤O¼¹£–ÇéÎDå»P7«©¤Yo¬ÏÎ|Qç«jžJ_ŒoˆC{æÔa$ß6C6Œ¬"?3%FÊA¦VUÿÙÉ1üB˜ŒÌg$Æ DþÖ²Fe‘^Ü‘eÖK²?ÿ~™7fØ#?~#ÿ@õ‘3´ø
Di‡±4G¾+Ÿ‘’#}ÕûååHîb×FÎ‘)ýjiËeLÓ‘}
®Žôö^CØ‘x¹eí¸ý»ý»ýû5þþ?ŸÛ'ï Š                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             