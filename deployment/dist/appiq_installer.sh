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
‹ è]†h ì½_oI–/6÷†áòóõsn÷Î¨¨­*ŠÔ¿nv«g)ŠRsZ”8$¥îÙA£:Y•ÅÊQUeMf)ŽZÀÅö‹a?øcqá…á‡ûÅð£_ýQöì›_}þEÄ‰ÈÈ"ÕÓÒîífÝ;ÛbfDdÄ‰'Nœ8çwzýô4›-ª_¼Çß­[·îß½›ÐïñomÞáÿò¿o'woÝÙ¸s÷Þý»·’[·ïlÜûErë}vÊü–Õ"-¡+gé|^uóES9(6­h‡‡’Øÿþçòû/þ›ÿòÿö¿ØOÉó£ä›D~øìÿüoþ÷Gøþý¿_­ÉíããCù'Öø_àÿuPäß¸çÿnPL{@üIÖ›—ÅY6Kgƒìÿæßþâþ]ëÿ-þ¿ÿãýyýkú¤¯¿ÌÒaV®¿?9péúß¸¬ÿ»wîü"yý>:þ~æëÿö­dºÈ§Ùƒûwoßƒÿ·ùIïî'Ÿ|ºñé­Oo·îÞOžî=Ü>ÜùrïånïuºX”½Ør}°ýÛ½íéøÅWçÓõÛü»;­;Ÿ&GPééïVURk¼õ/M‡ŸëWýú{ýÆeë×K°ÿoÞ…õ÷½öJ~?óõ/óßëO‹“|’uçÓÞtø#èqïÎwÑÿà¿·¯õ¿ò»Öÿ~Ö?YÿN|ràÒõ_ÓÿîßÙÜ¸Öÿ>Ä/®ÿÝº½	{ð'×úßOþ'ëÿ=îþ—­ÿÍ{5ýï.üëzÿÿ¿n·Û*‹I¶•ì$e1\É~:Þ([ó¬¬ŠYº•e³¼(›Š³jPæóE^Ì¶’/º­$Ù}U	sV2—òS.ŸTól§“üOùì4ÉgÉãÉr±€çél˜f)”|–.ò³,A©‘Rl¸êA³;e–.²*‰2/³q6«°ÔÁá£*Y¤ù¤(³a2‚~Êw¡z2ÌÎ²I1Ÿ§w Ô€¿;Ÿ¤(;íRoFù Ú/³?.ó2ÃÂU'YVÐ§G’g ²’yŠ½œÁì¨¬šQ^VøJ•ŸÎ` ùlƒ¤ƒÞUæÙl5ó¬Ú‚ÆÙ¿É$I×´0/‡Ý¼ê]¤Ó‰¼1E¢ïJ¤PwFŠ0=Z-ËŒÆç•Y¤Õ+Û‰‘´;,°úý45º0u“‹*¯\)K@ó¡)Ð(Ë%†é"5ß8™¦Ãî«WÕOMN÷t	33Ég™|b0Î¯&yµ¨ÑkÚµï°hñb9ïç³jQŸ!·l%ßC­mà‹qÖÀ¶dOFÓ‡ìÌcŠª¡'ŠÁ’ÿÕFV[K eÃ4édrÑÄ{†u5"Ãÿß¿`ÆZäU+`0Y™/àÿoô’›7¹ËÝÇÄ]º77o5€²PËPÅtˆ¹öÅ²œeqj>Z§LSyGVB²(–ƒ1¥ƒ˜û4«p:=6O^|cÙß4q0Ig4âa>e%t.1e³¤Êÿ”ñ§\:‹Ô|þÿ&Žî@XÇvƒK¸±íÁºYä£‹ú*M„Û¸}Í¢µ~åp¦ÁBÛ³aYäC³H£‘™ä¨Ôè‚²£ZÀ¬zß ö\<¤Û4$ ôÛJ~•gƒñ¹cõÜÍU¥ãiZ¾ª6²;"\$Åh„_OFËM*HÒÅõ]R]@Ce1ËÿDT­‘å„æš=•BBÌ
ØºÂr»Ì¼ƒ|Ìt‡%;A¾ŠnH,›­ð5SÁŠØy t‡ÁæûQgæã‹À4)–@Ûj™/Ò´¿Z:µ)RR~9âÇƒ‰åŒIÍÃse§¹™¬í3X¬ô˜|è–]7ùîæ8›Ì¿C2‹ó$­Ó«á`Ÿ˜@+‹qü]–uAzHq’¦òE,VÜæçzh‹cí@àbÅýtîVÆ¢°;¯,S“édºù‚©–½IŠ["ô/9ÏcS{à­Îª­¤i²Êd«µwcš\ 5
Ýpó'Êá¿ƒM}µ$F¹šÚ RšDÎ¥n5P6IK·tœØreÛ:Ð‰å¡Þ² çÃØé?vD
™òòƒ·æu÷Èp‚/÷Z­›7_ ØÞuÊÆHÛ-XaÝä¥´èJœ‹HƒOXhwOhIÍÒ³ü”¶‘ÚÀü]ÓYùn$X”ƒq¾ÈØ”…	8f¢ÉæÕ`R‘ðÕ¶=öön¼œžtGØó!l‡/€â"+ÒqÀ‚¤¥¤þ'÷`0§L)
í/—°âèíIº¼’Ø]+Ø÷av`Š& V5¬E¢&ØA"ÔrÂ;øb†}Ï]×üE¶›ƒ'DµYÕ»‚æd+7CÊK‚çpµàdeÓÄô²‚uã}Þ=Ž_\NIóÖÛŒ&[œå«$Áˆ‘£.Â1<î"V¯‘! óÉ¿ƒ‚wt^~ÂòÛ¸Ca¹«KúÛÔÀÏÜ¼¹½vsQ†~•<Ÿi9„5O»HÜL2)NA(²ÓË‡y1Í%Ì[ê5D/5“¶YÐ/‹syÛƒA±„Éd)#Ýp‹c‹úøÌ±Ä¯€ñÜ¢ØV‹Bz{œžÔ–c‘^E¹‹·ülž Å_a«å|^”®–áÊcáë¬8Ã‰5²œ»÷÷õ}»+KGÌ6ìúÝäi2j…ˆ²ÐÝÓÈ#ŠC™à‹ã–l²Ð8ˆTT
@ÎâpÔVÊóm—–•kÞÄÃR¶oÌLçeŽl¹àŽÎõ6Z‰@ô]ÔÞ|™¥“Åø«|±þ%°ü·¡î¬ÿîÞLË	fBažÅiÃpö-¼ùúæÍåø‰t†„±“¥ëçÃÓlaHµ=<ÃÎÍªñõ(;ËA@(Y(ÝÛI§ Mˆ5æãú1ÉOÊØ#€ªÎß{rÀZî¤	6Ço–Õ8™µ¦ez¸abEàÛ0¦æ•Wœ/JaF¨;ƒ‘Ÿ¡¼0ãÃ6<é’(›BÿRXÏ§ôü%ˆ¦b=]ó¿71Ï#-ªqJ'òA:O8 )JçE.˜÷º¸çzªÁ¶œOQ$mHtÁYŠ6ÖßðyÕ$Ô˜Zß}÷]Kf‚Þ#=²×ÛÊVëŸþüÿéÏÿþ"³ó‚ä°Ù–áýßƒ6êJZ<M­¸®Ù:]À‘õÇ%jc f'A©¼V«}„2÷ó¥l8x:˜ƒ“)ýg)M;c¹d±?†9DzúòÝ5MªW¥¡qÏgY›6-æYlëkˆÚ;nFG@d»°·ÛÄ«9ÍìE¸GºbV;ØÕCO¼Ï¡r@çÛ“lb6!ïPê
šE¸²°ùòNYTU×¨|ÜÃjA{æ,Ë†q±^ã';>ÐÑGó–+|äí«š½šT„­qc¤°[IYØJ>ß„…	½ÖËñA6Œ…¦QªÜ¾ukZ/®U(´qëÖþÃ÷8Ü_jj”äß`±•ìÃÈA#„
v?¡–Ô wPV.¬&Î1l´Dì&m²›-’Ûp4ýL¤¼¯êÉJíƒ½d‚ªºkmnüM½Ž,pe¼°ò>ú— `œ§¾Q Ô™ciIyš*Ôº‹«bX„AIµeã†ŠL]Ôj€e	3R"`}R,"¦åøÛ=·0h„(ïlr
k<Ûà–ñ5í…ÉÑ,«ilŸ[‚’2•-³~âÝFþâ½Í'5©cc(IYµ¸˜ðAÒ.à–x é0“’o÷fì¨m‹LiWdœ˜9íôÉ¤8!5
‹Õúft,:ï»6XpˆV¸ Kô)Ò†Û5¹P—cBë#îJjïØ#LD{=Ì`ºÅ®!¥"D•ÃÐÎà“Ì;	¹iÁåƒjã«Á@tð	Ñœ3%<˜3tû¦x”Ÿ.•²â«×¬©^ÈXlµpšzSáQá Ó=™˜ÍI8<Áæ•f‹´;ZNQ!`íD÷Ë¼"†ßJv&¨A*CÄ|YÎ‹Š™ø,,éÆžärÚ»yó8-qe ®Raû1£¯ÜÖ°¥
ž€t¨DÃ<ZÒ&‚õ9Õ}ÿ«ƒ=1oe)ò‰ƒeN§jþ>0'Š(UQB’)<€<lodàÂ<2&vOŠ±rÏ‹RÈhpÛáá/<7¤ÂÅ:}‡äq:ÈNŠ”.ª³;…n¬ÏÓªé8¬Ÿ)Wœ8“6ìñ§Y‰æ…E'!ÓÄÞ#i×4ËLNpSØûáxPÁvÛ½ÎÆ4’Çr8Åœ;²"ÝpÔ ;FT`eŠŠí§¹=dÔ¬ùx€\ i¯41ŸÑé5™³¤”=QŽ-òÁ“+°pãó¥œ"ÕÒBÁ=)–ÃP^Õ¬òî¨
%«mZ]þ8¨¼Ð§uØ5{¦2[ÑÇÉ³bÖ½„U´LÁ‹Çš¡|c•±…€~ ¡¬K%êãp;Ñ¨L±‰kÿCžÝfbÑ
9`ƒ#eL0D˜Ê‹¹V^ÿ¡{•©òaQŠI¥çÉN‘”âwp09KêDKäÑÁa'ÙÙ9Ø^£É÷Uô€p¢K–ä"Ä§^£É	[å§c”ÈÀÕ‚§Ø—q‡Æ“U=ô-x,,Pñ¢ªÅÄ;ß¹Y¯bZc¤8çGd§k¼ôa‹£\Á®sºDúGa.T»‚J@ÐOÔ-Ž´Z<ž 9À]0›¨´Ê]óŒ¦ß¨§õ®KÄ$½¸¼Ë¡ÁÓßN«²Åãò^ëO£:QÀ^Ï­6Hò{—‹¤GÆ™/ˆ©vÌ~ÁÓ¶;‡O6o–Ø$ÙŠJwu]lIÿ”$ýž?ÚÚ`G¤3ÙèRƒ‡yåâlOjÃÄGNuÌ^S?Cî|¥ÕA â Ÿ|ÛÈ6€ª>z·!Õè´¢_ÙŒ/ÓÜžÅ]½Z-ÞÜdp>ô §“	žûðÎÉnªù(9±]Á~«E2&³_ú[NS¯ä~ÄÞ('…ÔZhWÕÂø4³ý
Î>^QXi| å^9Žo:Á³žR°ýE;Y öd.qcÐø€Œqµýði±ÓIAuepÿÊ†Ë×$[zkzŒíÈrì¦‡¯©œ:Ì*(lÞÁk+9Ü=:^R¦óñoŸ‡ j#89C4Ú°º¿éÔnÉã‡˜ß.ùp»]¢Y·y®)¢çH4üÖ‹YÛÖíÉ¥£å4_ÏínîÙEi…@æ¾§C+ãHmŠÝÄ›Fì¦­Z8ÈfÙBÎDº¡³ådú™l¥Ày°ª‰»i¼}Vµ¶ã6g}9!š¼iÍ¬Ew-“IzRHHúùjx’9Xßf|	í£Q‹\L<û,_—åŒÏ×ûtÏr»‘s”YØuQW’‹kšG@q3sŒt¾×m¢h¦eÜ„[jm²B6$išÐ¥d6(`e‘Æ¦®:a°1Ú9I²‡ÿ°•f!§Ÿ*á{šr3~Ú›³×V:äáxëÁVsFÆš,—ñöÞïãF[¹+¹½øÏ2ùÛ-ÄòM³»‡ÖH¨ˆííÈå—å´,°d$C¹Xç¥J´DÛYžc}'5ÙŸßxKˆhäß~1Äy´	§BÈÏ.'ùLF°×ðp4Æ^‚AR‰©ô­uÞœÎ²À-H]Ï?RgÖð
žM,|p5¢ÇÚ!hõ¢/‹³ó21Qµ1näs$d—#0Õ³ž3p¶òç”hˆ¶¼9ÝXb];©R»²ÆÖµD<ZžLs¾4à#7NntÎŸë~gí sV}>;-è›Ò/Ô2éÈJ&€"ùh‹ÚJûÞ‹€ÚÁ¢}¤:*¦}ÜD#û1N_É0¿Ê.<wV	ªšdvb-p(;p¶Ã(ñì`¾ûpYá¢ô¬0«ÆxL[ØìÔXäÒ/¦éúC-~ÍiAî™´ì©—ü[ÈïE&º¡[‰ñ#ô]X”…‡]TÇ)œJÜÄÈ-ñ4ã1áOW'f,µ}ÔI_Ëï%O38meÉ«YqÎ¾-V&68¹ð¹wc2áÃu}›ôpÆÇyÁÔ|]|9ñWÿÒþË×¿¿ìÆÿYYú#¼{üßýÍÍ»×þÿäwÿ÷³þ5Åÿý˜ràãÿ6oÝ¿{û:þïCüâñ·?ùtóÎÆuüßOÿçÇÿ½ÝÿÒø?Œö÷øÿ×ûÿ‡øÕâÿœé¨!òo[E5¹Â—ÅÿYÎúá‘ä^9ûI'ä›ýj¾ÖVÒ	-pˆR>`Î*SÈ‹ØÙ+º@­wˆéó¬MÁ}+yQ~%/åsö2C0÷Ž×u„‹Äø™ÐŒƒ^¿¿ ?;Úçg#ü$Ò¦yŽù$Ü`mkˆè«\ß«ìÂÜçÆ g"út@ŸuB:2aM]Õ.z 7›uqVùËÂ²l,ðÍÅôyl+n<|ôZ”hã±Õ3tQÍŒÉ×ˆµRŽé‚–ì‘l(K'YËÅñÕ\§œ…Ê´þØêlÙð&¼ëXßYž QßÝx<Éßt(/ÖæR·¡É°åE·$ÉqQL^ac·¤[sjÅúôì™†öÓÅ`¬,¶tkaŒ–‹ëóÌ |ÝªÃøèúu0ÉR?~¦,)FîQ1Á	ªÌ½(³à$½€‡!Y¦àè%m=·†:ø_j¯â[©·kâ¹ÐVg23	ƒeIA›ƒb˜!_ù@RØbæSRÞh–ºÂ_Î¼nRHß47&|˜€l6FU}$Ô0¼ ø.rX›ö‹Èva,¤RSYîÒÀ3Žû|F@êà=OWR;”¼ßyË°¶¡QZ:x–5›bï” ü!¯ÇGgÍÓô•¹„Í†JZ¦'Årq¥MzÕÖÌuùÄL{ëëq6£žàí®bTèAgÌ©MÃ£˜o“[Ý$Eó*y.ò[ßâ›? rÇ,	~%üïàóç)z¿¥¯óérJÉ+ÈÅ¾ÀmÞè/f]cñùS%ãütÜÕöï¸‹‰ß‘xx²¿,¼€ƒûõÿ‘O.`Uã+
î#§@ÙÆáE+l`OUq‡|ÅÏÇiÅï ¬éóœ‚7ÈTñ(YZ²‡¢8‘ìŠŠ¼|±!u§]0l„
ÒœÝ½R¹ }Z€®ž’Ï›ÜCxÄæ&nTämnlõ™ùª¹ÆQ×ß€`9"UTÕ¼ò‡ò
ºÂ-­«ÒÎÇÚ±¢–?ùuv‚séu£‡Æè2Ž®¦—>‡ÒZ6ÐœŒórØá/4ùènãò:ìhr½°PEYOÃƒ°Áç°»vA9ê¦y)wŒ|Q"ìÇ+hDûå0Ãp¡.úQgârÁ¿–K¦w}žš'W&Ä.l¾§û—’®3‘¸íO¢Qûðv­Ø#‘WÉq™e¥‰úÅ.®“y	|°þmÉM	Ã4Ñä@t„«9l‘×[‹øåVÛVBµZ^'ˆ‹l˜(¨½C÷Mü¯#ÚÊÑé¿ûŸœÜç X¥1QwH¹Ðj{§p·÷aÒÊP~˜ƒº¬Ï\L÷ZžøÝ>¾˜gÝ*¡÷,V¥Nó—¢]6*ÜU:|˜Îó¡¾ˆ]Õß§Åy×ôYîà¡wè_ôøˆîÆÐÙ·ZèÆ£ÝE=SöåË}Ý¹§(Î`9¯s{—ÒúÇÄt&ÔœÙ´W¿‹/àÜX’vŠòâ1H””
tŽŠtÒèÀÜQØ|Ð¹FÓš´«1;Ý4›ñIß³{CäÊïÊä83]XylÛäò£þ€_òáp’a°Lœg´â.Rñø«ä·Ë¬¼ÐS¢¶Ìîc•XÝgaUÑI» ë&r©D$šŸNòÙë<#&‹u\ŽÜeÖp04RuY˜GâF¨ƒÍ½Eò;õp™OÝÜù†u’gE¢-<#ÖÓ{KxÀ:býVÇ!î;'a œ*¼ä» ¨Ð'MV7ì<ëÊqqP”ÙzùÔÆÍÐ]XÎA5ŸD:§¦hÔuQO²ojuÈ_m=øÜ®ïÄÖ"P”„÷™‡¨ê™ 
8Ý‘wK½ê"ŸTáç^,ÄHv«z8äŒã²Ö½j&XËkqß2>&M]l>GêÔ¿&û36ëò6ñ†vÿÍß×Þ3.Î´X ÊÍD…p‰í _¸¦×ÇìðÎ#õÌÐç£ÊÙçx]¾/O.jqDÑxT^5D<â.rG]à ãŽa^­¨½ºƒXiÅC&Tßwa<ºº©8–0ƒ×ô	póä³›Ò1j!QM­Ì¡€¿L$0ÀÓ…M'åýº«øX!“‘nçš0•pÊzCÐmö¹1T•_‰§¨¿p>vQp/öT!USÀMjëMÆ­ã|qƒÅÝ·¦>'Js(NPXÓç5ŠbŠ’àþA­ŠULr¶ñøßõëŠ¯^›aDIðU3M©ñs¬ë\ÅT-ó%8¥¿
‰
uä<Ë3LeZ~ïj›‰ÑþkŒ«êM|Š~,:?OÚù(ÁUvÊëîísÑÀLÛ-Ô¾Q½\€ÎªÒrtÔ0X+w‘¦}äÏ–«ë{cms´[záYvž…Ö[DuÏ`ß€è¬\î<F:+f]õ¨îÁë Ý®ælM¼k¶qÈõÌÙ-ZÎ×Lï)½l6°¼‘ïZœx¶õ‰µPhOIÜ‡T ­î¾µM°#¢AÌ(¼[¡Øa¶~–5V/Óów°]×î&r®A›ï™ÄY<¸ÑrØ—[ì~Ûhú^eø&[¶ïÙmUWÜÿ ¶<?Ž:£½/ÿ(q©°FP‰³5˜e†‹…M™ƒ­ÁnÛ:&‡ükÌßf{Å²ÎšeÔm†JÃi7Í×Œ¹ÙhD˜ ÙŒV#1í®²”û|k—Ýœ«Á7™ª^TŠ’p2HìPë[Þ9ñû2‰©’ƒåÀ{Íhäørßô½lÇÎâ´ó…™GRcGr½ƒ
ÃeÍŸµÖQ:œa7‡yeÀN€çñ^ÖÈ€(è"uÈÓxà‹ùmÀ«¥É¤8§ÛC‘êÃXIAV¡³ñb‚‘Ý6-ytø;;ÆK…ç¦[PçEÅáÝðèÂPdró3]Ny×Æ&šàÝQ	[&vœîE±72äÐÙ¬« ¿É|Q²¨ÝëÉ«ÇáÆ.£áp¡´¦¨›±6Áð¢úãÒ ´±44‚±´,Ïy¡4–'d|1A2µh#ñf×üiÊì+ßô}ÿnË‡dK†•~Á ‹Ç`”3±³OU2j"™dX­ô8%t†&‹‰3ÿ9!L÷º£2ïœÀD‰<	.°î® ¿-®'‡$c—Gh'ó‚+/Ò‰"œ„Iñ”†ñÆÂŸ´ec±ÌlfµÊ8PD‡¢˜p_*¤§)^ãû;ÈBayÁCÆ
¶æÕ¨fWH¨—……—£šéÄ¡;=7Ëé~Jâºø†<Œ“nÝí™ñˆ°ññ c·°-í”Žÿ¯r¼YÕ|a–âK}4WYÊC†\•þÆà||ßMÑK<ôCÿï?¦ÿ:ò¿Ü»uíÿõA~×þß?ë_“ÿ÷)~Hþ—[÷®ý¿?Ä/îÿýé­ÛwîÜûôÚÿû'ÿóý¿ßÇîÙú¿sçö{õü/×þßäWóÿþí6(àp€Êšs¿ÔlËÜÀ¡õLÊþpGp{ì³ÀÔO¹â†+Ætd•2ï|`Bãþ¡Ò–¦ãAÍ!¥n¢
ò6¼ƒ¿8~
½³¦d.T /‚šÝ¿¥$µ+¯%uQ#o,ã‘¡±”9=ùÞŸ[¸®ä9†{¥þ˜þ@¯qÅû—3Àç±Ë¦\Û€²Ïd"ÜW¹´™`;§rÃË«sÄni/Å¸äâvOm'L¿‚ä(¦Šœ§}$R&nÎñâÂ«ðÃg8®e•8HWƒNC=¯¡—bŒ¹À³!ÊÒyc±:yHf¶Xf‡fÃüÍpävJ·tW'
¶æÜ§Â«ÞDG«c‹GZZ;ì!ÔKñ:NåÈ‡-hÅ³ÑÔ 	ò£­síQùX²bÊDòœñLª8ô<üä·'Æp|Ì1®€¦KÚ.‡îä8¼Bè\KzÅ^0ª&!þÖ{»SLÐipíbSòUvA Ž†ÉÄÝÜÅrÍ€\
ÜÝíf¡<Ö£È„™L \QmX•±J3YEÝ¡s}°a¯úræ­OG<ªl½ëkûÈw|5E™]Ò Ü" ùß÷¶¬/¼mixöÉs’Wb½ÉMÞ“üµô4WØ þÒD4Ó,[ð^„’'Í|Çb@F¶O-©¼44á–` X½ýb?]”ùktZC‰è¿4þj~Y[žŒ‹YF^¡“ˆ7¿ÝØ\ß¸½¾qg}ã.z NÖ6C2.ut=©|´…U¦™ú½<(èàkq%B°ðò4ÓÍ»†ÓasáÝv^ª’·î"Ö¿”2Å™/…åþì}.Ÿå”€î×\Q[hÿRöF+î;Oô\¢õ÷WÐú’YwcMŠ›OÑ…Úrj.²¡mVœÍ^õ®¼ b]D#Pô4…í;½[Áâ½ÿ©STÜ—Ûw¹Ð½h!vËnßã2÷½2fˆ»¯ãMI,ò7zþ½]1gÿÿ_Í¢ýx’žVã|nV[¤Óù°[À`û ˜/d‡¤›½ ’éàSQcÚ—„u®
Z\B™…Õ\aJ5p†tÈj]mS~c£Ëþwûrö° úÎ	«†ö~l0énÞ4bÐ0ÊÁE™Nó¡ð9s­¯”Ÿ-Òužnì¨|†}ÄK•öZò:H Yíâ1¦ë°…êF'‘rI2¡¸ÉZ9ëwñ™+¶_^mÏó#vPÁ¡ÿärôªlñbÞ¶ŸH‚’Éƒ ¥öÚgRÐ}
Õz…‡Øvj«míJ+o×TWpÒÛ7ªq±œ ÊíÍøjîC¡ÈÕ×YŽiôhc-'Lž”2˜Àl—Ä¶ò`D kœo$’Oæƒä÷Òe–m˜ÃäÆ´†^¤ðO¤ýµoÍX±H¤_ãè‡cƒíµµâ–nÏªó¬l·û¦SPCØROõu°ðú	ãr²€¦çi¾PdvßŠ4RÁæcÚá¶¹¡NìûÍtG¬¬s¨‚ ·õâÑžN¯Dó+Sì?Øåz×|ÞF)•ü*:TþPŒTQµÝÎ«íÏÃÏ|ßñH‚ÿ÷m±$tpË”ywÙ}É*V•½Œ¤æw•¥ø0¯æxžšé5²!*T‰†´—ÇØ
]©—Wdw¤:û¿ò–žÑ#ÇAÁ4ÑÛ9ôðìÒ2lKå§Ü—¦É‘?˜o¹³½9§xÄmyXlg8¥¹‡	eÚJNŠ‰ù\wú]6(€-T<ÈeÑCÇ/;Î'C‹'ÝYÓeÔöŸW\f@îaïäIÚ;y9À]É$mÛ3s	|ˆåªç3ù|ÓBlâ'‘!²á;óDß.z~_DeŸ¡•’ï—­²aÛôðš»BîÂ´ƒyYÉPNŒéF'ËvgÃî¢èÂ$WCƒ8c@o,Rk¨Y®þ*#kc¦Âfnåé„#b¿þYÓ4ƒv‡Y &YlûÿóŒv	<ÒÊ"›ÅúUvÑÆÿÝ ÂýÐêŠÙµµøy
6Cž!oÊtRÅZÉ°&
¨u"Ã„ýQžM†Ð‡Nrkümö:E:âÝâx¿š[4xàºQólcóöÈmuñnÔ«¨Î_L>±ÈjSAëUN¸Qyk;û\zé²ˆ†[DÕ}ÏÒa- »æ¢ñ“K<ÝÕô~òéúü!—F'™ÕDâr×Â­tFWöË}&¯EÚ¡x‡­äÐvEp6üÜ>þâ3¶ÊdpÌvÓÁ¸í¾‘øM€g1·¯Ÿš	ªì`–=j{íXÒÒ—s§KŽ2ôçæà)«±O.`Ü,tÏ‚]‹¼Þ©»fÏz“¬Ü§’·²Qy]C=°‡OÑ‚–_bî¡ö¾Ãqí{Û°Ún¸F^…ŠlP×IqO‡¯ØE«WÛ|V*J©ZÇ±Â—éYö8{´ïlø5ðTûÆº	•»ÑHy
ÌHo'ŸÕê*4o¢ÜèôÀ”C^ xÃö/ûÚµ:}]i'c­‘p­WÒw*3ŸÂöíú…ÿábs)À¼]²O4 ¾m#ÞZDBJ°¬ÕÊÙÉ}P”e†žÑ^yÍ®èRZ«˜ýí÷ßšm_ÚÛJå23Pˆ(1­¬êÑÌèoUù#o ÚÃÚÞ0yŸâ®¶?Ç”¼éõz¶Oo“õ/|†SíàFHýêÚÓÇ<Ÿ³ãr¹_´ë¬f(Dëï"¯@³˜eÜõ5m‚=7`AwüR›õR›¶Ô·Ítz½ÐT’6ëÄÂa<xc:ùÖLÔƒ7#ØÏ³·nŽ¼±s„4¥5óûÔEÅÍ*BÓU6/^è«O)V²ºÂ,<ŸíAñ*ýÀqÜgW–¼z–þrÊ[Ý8œû"œû¢p#áŠjhoU©ÈÔõ£>£vÎ3”DÐ¦™¬	oõíÑm†öû[ßÖä¦õð$Ù£lQ¼V"+H2þXÔj;Ã¼åoO&íº¤gáË–Ø_ŒâñÈç'¥3\ÒB™áŒ¨eIáLÙ‰â‡è^TSâµú'Û;Æ´O.zù°¦½“ŽìCqÕ<Ú«áùl¾\Pc Ûñ¬7©ãÑV¬êi(¢‚›~ÖÔïhã¡Â±‰°W½QæÙ m_f¹ƒO&jzñ&î2r\Çá5¼—APZ¾†øêfh´@$êùC›ÃNßÇ<åË}æ¨ÝZì“!Gm%Ÿ'·3b€„)·!åê	q‹…+uW’i…_H2`ÿ%½0WÜXÏ¨¥¯lJbôTeþìaE«­äÌk…ÑÙ‚dc‚øàECOöP$†úòËZgHî‰Ë‰ÍýùeÆå»{ë—êjÇxRìÑm 1]4·¯ŒZàI‚rÛ=hÊ<çª,Ìne>5ÄèXÊSÈƒ[ÉSš¿“úÙÕ‚ËsÅ©Ød%	‹6›FR•¡Qy4›GØèV-Šù9Ç>@¯þw{­×£¶jGê&Ùþ	ýrJ·=èá¿j¯ZoKe“t^eÃ}ÄR“õ×®ªcÐXÚ·oÝºåÛÝcPÒ)A „Çö.ôBmU›§è!wša¶ªEÖÞ€¯BEÐp³×´óÜÀý:ùkzP3‰üevÆ£A:B$LßªxRzõ2ÏÎ{'Ë|¢4#óÃÞï`Ž¶-Ho’ÍNãN¤ØCnÁÙ)1_˜~ç8‡É*™óºÄÒ¦DŸø=Õúv-üFðà‡5÷9á®L¤žÅ¡1‡ê©gR7ÔZë`ŠÕ
f &±ràŒþe6§jZrd¹¬=+$ñéOMk®Æñ8¯’sRjN2“Gx( \åûÔ?¢qj0?‰dg—‰_TÆ'ym„Ö¶‡£¸"ßH³»˜vö]fc¸ˆÁ—Vò›üa¬ÁÒ>¡y9]‡Ë’µTò'ÅOÇ†zÅ“i‰Ú>¹ùÞÎöRè)nx Øš¸‡‚Cg¹¤€V·¯TÎû®…#eA*Šv_1ei|Š'*­¼£†l45bÄü…&3Þ)—UÆ1åOaIèVÐWt”„^Óæ¹~iýÌ¨RÉ×ÓîH^h1¹Û”yÅQ©IÔ‹Ù, #¬§À÷¨h²9VçùˆvGëqh'cÇ¸"·ü^*gB­¹¹hLÝF’‡¡Û#1F‰XÉ5õ‰Ãw}/»Izs~‚Õ,†ê°_~œk -£[\‹$¡æ°mA–“\¾Z|tc4ƒÀMžQ/Âx9‚ArýÏ9°Ö•±§é‚Ì¦Ãt$€µÝCiOqÏPH¢À:BrSyèsíK&;1ùdRøí)ã·Ô•j&È™®P'·§ù•%†MŽ
‡[PdLï+ò2Ò@›ù¢å9Àë“Xq£&¡xà	¶Ší_˜-ä{ã^ûƒÙÞ6°‚ëÍ¬ª(“ˆÿVf’MÀrOajðÀ¤Èx	«~>.™Ý…›ø˜]ÏŠ››xDÈš5ÞÄÁsV] dÛ;â”;ÝiŸeÚ/â^n~Âî:¯æAtXw‹tBT¸#Tu†åiøàB†,«Ú1Fjšäß>+_I?nìa~hå™¶ŠéˆÓp†©×[á¸’Á’[€¼cY‹à0§í²‹ÞË%uÍÿšâ°*¨4-IùêÒË^§ÀNñÐ’U®ªÒsé³[	ß…ßÐp1;Nç ¤WÏŠÅ³ådÒ¬7r¼}Û&¼õ½;!©ì§Z'§œ#Íøàlä¶=™¸ÛŠÆº÷œz÷À5 ¨Ð;geÖÅy˜Ñ¹ÿÑ#ªýºG´Ùê"yð€î<ÖtÕi:Vô
-
<49u;öf!Inì¢9OÍ×±¾iÝÃpVo<.ÊÓb‘ØÂòæÛæ‹ä$Lž,ê=;ª‡/“m‚Rjq¦éÚk«Ó2<Ý‘ÀÓ9ÔìE×­Y•“
K·0ÙlP^ÌMø†)	’‰ºó!‰¤5‘„©>üí´Ë;·O)Ä)õÁŒ¼ú—39K'y2WvõlÒÜÔÑÑÓõã§G!,RwßÄ˜0z’…Ñn‚ð•.ú6qÕƒhb³n>#`ð)õ& Žã¢
­û$8o‰K¤ß¢Ô[h*—ž~ÕAÈÆÄ	ÿ H?ñY: ØŸOŠ×‘a«sYŠØ¿\,¼>×³u;mÄXPŸ½}t`c%Š9(œêh¡“ý-ÜNX¡²”ˆ›ík–5…=´" >ÑÕ]ãMOÍ&xrFpK·pS¶_°Ád­FõzÁÙ…µy!1GŽÁ•ÐÒÔ©õ•a{çt¸²‘7µ~gˆûŽ@ô#¤°Ò}¼­ú¸ã	Õ>]uÝG-µÂÎ‘»®þž‡íÝÕ;ÿn©öÝàêiš!¬Z^MkÓè¦ó6+P¸ýu«+ÄKsÝ¶æð»Ôí¥…~ÚÁé,`‘ÍÇþµkçt»ST3ÇÓ0
Î•þÊ“}^„ ûü!¦—Ÿ&³åô–‹˜m|‰:m;¢„.:rÛ(L¾¦L@î½€4©b;vYØ-ã(eð!miØó_“H=V¾YÀXùEY®H”biÙr¼VáO¨5I/¿LË)­1Å÷d’"b&šVpÜZtm†‘›Ö
a±	â“ï)h""%)C1Z ò::çZÃ¥„)dcNCdF
D›æ3ÕÈóå¢[Œº´ëqšf9ƒåÇ;ƒÝˆÑto†9Ã’ù²„åPÅwÖ£å‰=ËÕvVL5‡ äzŸ ÔV‰ªƒ¹Z“v.—$\OÍ$0ç-ç®âªH¯7>ËOæŒvP@g.Ç9¨Q1CpZít Ëx‡_ÊÄdC;!Û OéA@ñ Æ[Ð‚se¡ÑaGîC@cf¨c‹]›¦c=zô•ûqïN=šÓãÊ“%ùTi+œt1+Mžz¶žþŽtŽg™“Œ¨1<]„"™€HFm›¢
c˜6@/tš47ƒpM(Æh“‚žøÊê‡§nqIÁ´/žéÄÞáÚ§LïöÖ:JV[É'wù7!9ª mÖ}_/¬t*°u­JÍOy‹m“A<c†© ‚pš’E-Mè©¤â¡Þ§Ø-‰üŸRa¬NíºP>øÕAt@‘“¹’(Võ¬ÝB+‰¦
ë…>ÂÕ³‡:ú‰â™q«F
ó;'2¥ˆýH…Éë‘á ?@Ìc…o2[½ZN‘Æ¼Œ£Á»tÃÎ–r‚/Ø’0]™Ö­ €s ˜GõFEÉ¹•Z‘|-ç¶òSÿ¥ž¨tqÃ»å¨ozÆøoÕºÇøÓ“÷ŒC:½JŽ 'Åú¬èž6Ý1-^2"åÍÄ<!p 8ˆ¥ÉÏ`¬¬T	jÖnÖÅp¯ØñVƒÞ~Â’šx'–¬ÐÃb€„ÖÜn
vç<CøÐUÌV?$èS`cÐ§†Ñ¡T«9 TÑoQ<ÚÊÔnqzÌ»äÐË0f=]xQíÆÒdlls‡ðö¤¬iHAèËøõÃd’¿B.ÆQ±ù»˜]‚ùsþ…øŸåôG{wüÏû›wî\ã}ß5þçÏú×„ÿùcÊwÆÿÜ¼uÿþæ5þç‡øÅñ?ïÝ½}ëÖ'×øŸ?ýŸÿù>vÿËÖÿí»w7ï‡ûÿ­ëýÿÃüjøŸ4¡n«ìÐ®ðeÀŸ=Ÿ,tÃ,›{Ð†Í Z
ó1 ÿŒ€.bvõ‰¤Fˆdd·Ù9:u0ÏV˜ˆ:ÁFÙUU/lòŠ9dÔ’y®Š—bÍðžÚƒ ´ù14-K ‚¦;VÆæŠ³:h&8A_ÓÆÄÝð­+No\«?¿kSO®É1…Û¬§œ<M.a-7
eEJªlž;6N_Grv¼D~¤ðEÕ;Ig)Â‚’­EaI	rÍ#gêt›XOÐtåás,™Ï1•¹u¢Z…¯‰p1“IfßÔ!žÅ-Ó3›ZGû4’RGêë™ßRÔlÎG£HF“ì€—µìK5¨RÓC{·»·þâßÌÜPM±1uç¥ŸeØük4IE€‰«¤¦¨Žd:t¶§Ž6/­5òOæe1¥ùš”h×T1q œ=;”FÊ}9à&Æ–á2+mÇ|ì†íe?jN~$¥Mbî6““£Ù}Ò¤³ZaÃ\(‘_C<WR›Àa$5Êp­õ.àœšg=€ÎbUÛ­ï¼y$;9Ix4‰‡€TI9#Y—^§R”U‚`¦²ñ‰l›Õ‡-•tÚE:L'ß‹²÷*g‘›ãâÐt@C|¦ËaN}ßÆÝ.ä&¹gÉ¤M+ü›p6Õî`Q69	ÒUöÿÈŽÛD4vóN5Áy‡ûC‹3íç·½üs±ažÓø>þ›æ¯ñZúŸÿñ?ý?hÙ?ü]÷ ÏŸò9E™NNA  ¤nÁb¸t:W•þÃÿLk’>è\œ©-vX-ÉpÝ/Æp+VûóŠ%¶‚:Æœ|ÉÛn”T@.Ä´é'¡‰ú‡ÿ-Ì2…ò3;‡~À¢Â´_3ÈF hüíÿô†¹±\_í&Ä%“=QpÅND¥Evæ§´áÙìêù©÷¼ÄÔÉ¯’Š=_–ƒTäNŽ7Cn7¼í×üV‚ÌÄ±êön<9ã N%Í ì7ñbO¾Ï™ÊÃt©âé]K<Y§të¦Ê,YÁ“ö®ŸC~mËM	eÌN4€”äHƒ€™(wúöÜ?Ø¡—ûùë|”@ïNv¹¼àþ¿ºõÆÈ|PSóªç
¿]K¶p{ÈÊ¶þVR´¦qÅæ(=æçèüÅì0&‡çwj"‡	OÙõí¹‰Øùë–¢EÒRQ¢+ðùLáÙ,o±âHÐÛdw
côúÏ h\ÊÕ7{Æf7àÎUŸÔ$X;S–tzçì¦Ð7` ê—W›
Û×Ü;‰Ñ›‡ èË9¬|ËZû|ì
ÙêoK)é3Ø³ý	(5óXÿ¯Ã78K‹—¹eN›žÌ©ÏdpL¬ mÆ9„‡qe&áø@p ¶ñ…üÌ+ÁìD%X¦ÊLi£%»Œzxƒ×…+Â ¸­…|ÐýI¶øÆÑü03ò¯ÙÎš4;+NÅ¡©×êñ;-W.ØÏ+!ŒŸ€,zÅIõ™{?d¼Ã×ÞbZS%XG~Ü¸aªâ©¾(&ˆ¸‘¨ö¿P_ëa¾V‘²­þšÊó÷¾à»R°£`XB¾÷…|Ù•¹"?,€Æm=ìPÂîàÆ©[Fú¡_U‡ÀG°¢ønÃ~AíÌÁÝßÍz‹‚	`|Ë=˜¬	M§”×¸*©¯L©s_Tð‘ÆœCí,r„Rm@q<9Ù5	QW§è±²8Þø=º(`}#¬ŠÐêÄ‰'d2&Å¯·ˆAK!äA– áG·˜½Ç;5êÏ@Ê¶éSÇïFÇ}Ë¼ÓzkD<¢êÈÛÏÞIàêÇ0šW—kþ¼aâu•]è ŒßÔ5ú‹F+¨:RŠv,‘À²[1çùPRHJHa÷­­d&±(oa1z‚¢;ÈÊÊ´Ze‹§¦©6‰çŽD!)tÜ=7\¤7O/ð™°~Ç´øˆºzis"ñbmÕ¿¨×˜ýÐ.øÒ/ÉùÃ>õ¶cazhËMk9{Õ‚“ž¼yŽ±¶ÐZ€“xš©Â1–ÇÝÍLòº§ŸN¿“¼Iá‚hcLÞªÑhyj¡é8Á­‘Œ†Õâuv»7õh
Béˆ´rÒÖðúÅ¥zFíÑ²Ï@ÄÜü»%y¿¸%ô“ÏœgøÖPM`±#k£œ²«À
»
*ÞÇ¾§å`Ê
cMAäLa5ó†ð°]ŽRBÎÊ38qzÝ2sü¹~úE»ŒÙÁ”Úh»ÎóÚ­¯Ü`Ýz}­C%!Â› HN7a£ÍêìbÜ•X…¿ÃV\¿ÏöM<ÃU¥O§47Õ’Å¯A$.JGä‹r›Ÿ™öà#RÌLl>5M²wÆùTö'SÊú4¤e•±/-µC©§1lë.‹5º°žÈaÖç›7÷jt:€»&Á¶¡œb¨‹=É	>bÕqšNnnl¬aµ²ÑK¾e€Û¤4âÎp‡4#1Þñú´²ÿãnµÀ´E[o(ß6¹>’Gc”‘F(õÈÄT,U+Œålvš‰[°!ƒ¡²h1è;8,Îg±ù2éÑÏ“uŒ%ßJÍÏ‘øŒv“ß'ß²û´ŸËË#=—b“·1„I3~¥ý#5ë)©‚dÛõtëL{Û?™u¶‹»‰G¡ýÞÜÐÈûGfª0,Üµ»ë›Ë+w+ íÑ"›S¢rêgSbÃL‚Ó‡ŸÐü²É…uW½,1f	±¡j¹v!A&d4,DjvÝ¶l|—_m‡±[ °s6^A´îs{S Ñf>q_ño,‡UÙkôSŠú,/®wÇCÖN[à«\G3§-|Ã¤øNfŒ‡ að’ŽN¥ë†½.x›aÈ	ÌFæ¾è®ÐöÌšÊo¿WìPÂ†•rEbª2})ÇJ;]yBl?v'w]®ÿ”ïhiÅÞJÉÕßÎe'Kþ‹/œg$ÎÈ¹Xº¯¯I¨(ÿí5	'ñ;Øó¯SŒ3ú•½TNßæ÷cdq€þ•H±ïÈ-¯ß'’}¹ÿ}@Úÿx	T¼uíÌå¯ýH;Ïÿ
€½u€ò…þ×ý«À}ôG`¤Á(T7oÊšÒ5pÅã­öw4Êïx°x9Q”¨òÐ-3²]VÔ†¼²[i<°A&š@ã	ÎaJhO° ¦•ØH&ÔÂÞ¯NÃNÔî¤s*6 Il¤WEYó¨Þ¸Ã6Ð0ÿ“Ù%œë Ñ–MŠ>]så8´‹±LZDÄB Ü:c™¤~ ´žù¥V§-¼è½Ê.:bÖ÷hë‰='°‹NK¡¼²eÎÈÎ+_Â´!ô-o1R†TÓVjé2Û¥I5Øa)•XiåY©w”‘XdTå.D·ëÑ%°ªåI­ŒrðR%áÃŽ]‰»ÀÔìç
ˆ0>ö3ÊöAÃ¤—Ú”ça}á³êJ|û8…‰¦2¸ñžðªV‚ºÔJŒa+¤ØÀ^–/Ö#ý“ÍKÔ¼òDË «ê%­Á9yw4A{UñªŠí8ç{4$p¥#+#"þ©‡rVU’VYOŒ½&­ŸØMÃ¡m¨MÚo·þ—25H+ÌaŸÛˆ¥¼Áÿ‹èàBÍ›ƒê±—A
‡]î÷êÝ·f)qç`EÊ¹’lU^÷b&XbÜ|mÚ†dHWk©-éÁü¿ýÚ‘ãÁ÷oóV÷çÁý—)‹+0Þž'ÀAP¶ßØ¥Ä –À¬Ç»ûý/w÷ž|y¬Ö!;z/“›ÜŽ+äýùvÍa
eg’ÏçÙðhy‚!Ÿfš¾>.i`ÀqÑVñàÍÆ-Sõš,ÎíÊ=åyúÌ£1ý!þ’ö—°jD¥ƒð´
N´T[¡f(MýOð.ÀÍ˜Ü|H\ÜfäPºp.^0Hw\w¸1ÊÉƒê=†·ºÜüòÇ8ü…Kîr¢w2æã½|vV¼Ê¸í^›7"vHl#­äÚÉ˜•Ø @íÙdm‘ÛÎVç²ÆÝxœÂV0Äà8ÜWf©ÅÆÙJþúMfŒPooxK+Ã%ÑLÜŠéÚI§pŒ÷' \fŠè™Zózøë/’Eú*;ÈÉbPš©;Ï¯s‰äùýÕŽöñ–„¾
*ÝÃÿPm·7ò‘}‹=¢?zêªÃzû2®ÕO7oyÏ¿$Û-Æ¢^ÐÇåHŒÝµó€L6•k¾Šƒcž&1±‘žH$Ž)³˜y<„ó•{·U‹êr[›þ–%¥§\šOÑù”n ÞÈKn©Â;Ã²˜&î5XteÍ}ÖRÖmo!ïÙÇtõá–µS³AûeöZÙjjôß»žWzå]cÀ¦ã™ê¼ÃE~ÏR^®y¾åŠ´PÓÅöž$)/DGÝ5éZm2û[!¥rd@ÎŽÙÁw‹5½9å¯P[Ù¾é¤îYmí0ˆ†x‚(ÖåHZ
ÝK}ãå²”#‹p·¿Ç¦ùNfo½MÌ7ôz'¶ûòËþô’Þ‰„l?tFã\$œˆñfx¬<¢^—ÈŒ•ý§¡Ÿ·ì_Ì¸•¡±õÿ5§ÿé¨Š[ºuHÎG23£fút³K™GÌt†!£2°G[é“Tãâ<Èzs>_õÍ·ÝR’¯5¼Î8ä­•ýQ9æß¡KÑ‹8îDýË™ÉûN£ÞžÕj&¢½”jà+p­”tUÌõÑÏvÃoYÙ·–Ï[˜ˆÎ~ °š³ §"Á]!½AK©ÜÉÅ tMÉ0¶.´é`µµº=3QìHG5Œ¤Ác±qhÒŸ”‹-å<%Ë¯Ø2tñ’à{‚	¼¶ï³úÕEPâyŸ°öôGxîÆü ²‚vyÒ_{³Q!OðŸkÊŠ¥ÏÕ ]â=íÉt‡çÄJ/ÕšÐ81Ê¼A™Vcº. Ìs•å:*6+óm\(Ž’=3ÂÚýóçôø±±(¬á¸NÖ¿¤ÆhžzfZ?óYÓ9ÜÇôx’ý*bJö!…}©ÑL`èUô¾Áa|`Zóêµ£>™&ÈåhW-´àw-òDŠ¹lšöÎñÖ¤u¶¸"ÕØ’ŠŠ‘¼3Á¯éPýtÔ0ø&¹ï™Oú“ÕvÜ€Â¢g‘/…ÄdëoµŽÕ¥u¥Öº÷è_Ò
#ÆýæHZ Œ¸¢û‡
5´K¦’ÀÑäŽ¦‡WÌ`÷Þ}¶sø»ƒã½çÏú_íþý×0* ëÀ»0þŸyÂ€©N-‹Õ(;Eü§Ò™+´Z¾Âù_o{÷¨'/ÚÔT‡‡ßÛµšË›rÎô*>è·‰sìÇÖê"ŽGåóŒSMÿŒæÑD:sê:#=F!òW®[†ç‡gEf¤’mÛNœ\Ÿi~·9"Ú6¡Þ‹ÅèŸïpi5˜ŒÁ©± 27b°Ž@SÃœ!Sí>€3½~+zÜ5QMïã÷}÷î»à¿À÷®ã¿?ÈïÿågýsÀ/ïO\ºþCü—{wïß¹Æù¿(þË§ŸÜýôþÆ§w®ñ_~ò?Õ¯¿—o\¶þq½øëÿÎý[°þï¾—Þ¿Ÿùúæ¿×2äüQá~ þß½»w¯ñ>ÌïZÿûYÿ‚õïÔÁQü ü¿Û·®ñÿ>È¯Aÿûäö½Oï\ë?ý_°þßÃîÙúß¸skãn¸ÿß¾³q½ÿˆßÇ	Ï9å‹:Øû­øEx=då”òYÉXëùà^[—äáø7ò¤¬ {©C÷|ŠòëLlkœ`ºStKkµŽÇ™kÍäÝì04ÒrŽ´ž’‘˜›"C°7†Ÿï%{‚>V.SEžRËSò/¥›y¼{Iªl"wØØ”Qú1nk.s¼”gð;8¶jÔ˜biˆÎ[P)/m”©`íÈx9¹™Ã™.†Oþ1†§Iô^6O6èæ€úÎiVMß‰¦†”çùd’¤Õ«-jòŸÿñþ}òu6·d¼¾„þªÕúš`×±ýbdFjH–2<–@„f¿naTÕL¢3Ê³É!²seË÷¨Ôn@Ž_Ãh«‡eqnÙE/ˆ~ÃbY¹6[­ÎÀÔò5Á¶º¹ånß‰h›@´ÃG”‹¦™â•ZÛ#¾Äv’|Á„#HDCºÿðßsqÆƒa2ýy9ñ‰>¾{µ>,Õ:^B€NÕëÁ4?*ˆFãñ½:”(+Zñ×­öï N5¦äÚ°BW/E¶$n”ë‹A†}] :I•‚ÔŸ¡ÌZœ2° û³"$Îí­De~3+¡­¦ïöÖZ±vvnø c†Ã\¢>­Ë¥%§¥ßÿk)‰<âÐF·ërXà†ÝL¥!“ò1§È3-0ËNÂDEUumñ#¼®žònTãE©ÈúoÒ³”#0–/¼•‚y1kèÖ·)gÈN²ÙAÂßé~g+ùÚJÀÍ—ï]Û"5:WIFþlQz#7"0$[ÆwþyjtD”ÐH¿“Õk‘Ú`©E+ég¯f˜‚r—»uïÍ‰-PëÍ®YüªKIF²®¢­D»g›ª¥¬ÐíQ&qCr7IÇLwr«[=E[-™¶	%çeF¬Råv¶é$CBr9VúXp97+"›åe1ãxÚƒ	£ldø:8w”Ÿ.MpîmÎ¤™£ìBY¶óvF}]ê–6GK“Z²4ð7æ]”EAÙÉNMž.dÓ!iráœöEi>júÁ‰d$˜¶m‹=GðŒ3ÊµŒA¼Ô/ë‡U,óå¢b÷>ö>v;(º³àºÃ¸õ-Ñ‚Z?ÇQ(°Ñº–ÉZ&{dùémõ2¼ôôþ§ÿøßRÀL÷_‰š#U\jæ.r,0R†üÏÿø?þ_|,Àð›[Éê]©û?$Œ§K ¡[	¡ÂŸm>6$ë	¤xž€€kXëï	bœúsZè[	Q2,Ì2y•VNr]:èD@“&Ç-d\t× jšÅMí#Ëî25Jî:02§¡žec²ÇÔO^|#I£Ï¦(õìÆæy­dŽ{¶®Iš0ü+Æù3J„í¸Á·ZkÈŒ9£ˆUNœd¶”OÍôEGo±¨(fä%Ø—	Úé<ë˜doðã~æW:N ¸'¬‘¼({.¢Ho‹­ÖCæïrÉ™ŽÍ±£òNÑ23Û«9YðO
¿OôB³ËÏ¨,Šo®j¥b½ßa)ƒ€f‡Ðž·a‚ó±Aú€ªÎû«–KØà1.ç¢ÒIvh +—ðÞœyµÙ‰‹	á fÀLar-¥ ‹<(DÇÇ”aÛ"™òÁ”|´&/<¡ÀºK
©e­Õ"¬må)X“añp!&mÉ+,lfZ¿¼¤^MUD*È¦¤] ¬t‹^”ƒ55êª¬#e)6iw .ÅZ+hÉ°ŠqhÀ0­ÕU¤LƒEÃÄEeÊ‰Í$qó÷1ØÆX oc„)ÉHNB+Tï8LŽPsÚ©‘Ë>:,æl1è­QóÇ&%ÅjsAjÐ.H™Ú÷“¯*5a1?TžÜUnü.|=rFÂ2ëºåÞ(êàé¥:&KP·dñ*b!ZoÎ·ÿQäÅ
• 28æò5z(ÑKÂxòªZbÊ Î)G`È“'ÎìÄþà²Çg¬BÌÁÌ3¢”;ïaíC\#À)á.RÌdÏÍ›–‘€“|Àó@³Âóf5D³˜XR%§7( 3Ša€ÊdŽ0•‘KëM‰ÈûutÚ)ÄzF«õIˆ£·+¥#Ÿ¨²¡‘è‚ÑOÜìËLÒOØD# ;nê'‹ðÒ‚3u„úkL™b~‘Xáa9E4ïÞ¶‘V‰I‘‰|Wë†(&výà¹ôp^ÌZñ·DòÆ×Ë&°ÅZ”à¿S4ñá*æñQ©–£ÔôG*ý1UÝ²I	#žÍ°hŠÜ|||Êp{$-ŽÇ·ƒ¼îäW(ä¶Zæ0K)"k§ÙÊî˜B[(ÿÓS^øP6I#@a[6ADHè]1¯ÌÆhQñ-Çùy(–¬ÎæŸ÷žÒ”Óì˜ìlºX7Ùž[MüáK+1M@à#å;8Ã¦3LqÚ§°n×)½‹åó9Nûº­±þiÎœùx¸jC’ê»éËˆëßÿõúvOoßxwÿï;·o_ßÿ}ßµÿÏÏúç~ÞŸxwÿï»÷îm\ûÿ|ˆ_ÜÿçÎ'ŸlÂl\ûÿüävÕ¿×oú½»ÿ÷íû÷7®ý¿?ÄÏÍ¿M¯k.å_ðwöÿÞÜ üÏ×úßø]ë?ëŸ[ÿµð?šxwÿïÛw7o]ëâ× ÿÝ‡)ûäþµþ÷“ÿ¹õÿ¾vÿËÖÿ;wïo„ûÿÝû×þßägæÓÞæÃ­Øåj×”éžm´L2¦H2xãÊeeE¹7z·àO¾nå4ã„l»€™lôÚã¶ù=zËË¸RŒMüÑ›70g}¬óö­í—hBÌúµZÎ2¡”î[Ú‘že0Œ\àñ“tx†jØUOA
x¥˜öuQ¯?±.ìºÂäËYÌªœOr¨ŠSW“¿0þðF“û½-û +|qÕ²)\ºÉ.BÚà]˜ñ8«|Ÿ3ƒ—ú‘ßl-	Ø‘$ÏPy‰ÑÙc`“¡Hn—tê’ómzD1ùŽä¦ËÞ
ÛùrÿË÷&­oÐ°†Y¦©ÁÜÔ˜o,g4¾51°õ¡?
fwAw$Ovð‘ç£fïu„0i["œ¦"ÚÓEeAÐŸY–kÝ7S¨|t×eªL
ŽæyšÅ8/‡ÝyZ"àäÃ	[g‡0¼ÉdIæXšý˜õ$£Z·"ï’{NZßKËâ[*N$üLþ³Þ{ì™æ-M{C¼·L'Ê1ÑÊ,i|®@RPis)'­oö’')q‚»¨tìù¯sÕúè^â­Ó>8|´F	²¥7)wiªØI ¯éé–M·}L¬ä|%½oÖÝd)¯\
zi×Ë´kÓ\3‡Q¯ƒ¦)R1)€#ãÂ%X4- Ï¹,ìš™öPãÂÑÛÝ’£ë”}:YBi¸GDd¿‹Áä]®ËU}dª1ì¡zµ•üDÌw¾í%_“$ú}ö´&ÎÌmîZ5Ÿñnƒd/JëÄÝšÏÛ)ò½øõGþÐo÷’ÏeNÜýr9É¾`§Ô2e%º!ð'Ñëº‘y—ÑqÒ&éÝü¨še¹ZŽwâ<’§9}å´H'Uïóu¿/~_Ù­I&Ô²•|·bGý®e% '/F˜¸JRHa“²»íš—6¿T£ˆ<G¶¹Dšsž¸‘%AVQjõ@æ&K˜4é„]n^e–ë{ôeÞ˜ú‘ñÌêvt‡µJyZ)ùDI“oÞôäš*ˆƒŠ‹ò~Ó7ƒ­¼*±Q¾ Þôe×3RôÍq•Íl£ð)÷æ¡Cö]V©~UÀ¶}÷¾ËfÏ_Un}NÃNrÅÖ–ÿ`ÊW@xÕ}Ìq.§]ã9Þ¡9â¯Ô{ß…§æÏ¾`¯Ó¡>ÂM­05Z{oüç¡¾Š·«)½ëÜPêÄV>*Ð€]Œ‹ÎW¨Õ¸Bók^—Fw³«O´Jµ./¬’E@±ë‰ü/6uVªIž&ü þ¢Ì_ûÛ ¯Ù^ÃÊÓÙu9þÄX´ZCÍ˜Û È¨"(ß¼ù8CŸ1k_Õ›Á7oÔ«þ ?Lÿ–§P¿S¹QlØ†uØ]‚øáÌe[PUÜß‰qf§oß®ß%¦2gÇ½v<­=hŒ¢™úÍ¶è½«7o0ÞT´‘7oÖ‘”ñ1k3¿Â¼m¢_Ÿ7rE€dÊE…­Â#Òžõ-×y3ó4KKÒ¾¡þ™Ö¸æD^÷øºqUƒî*»|Nþê+~ö?ZÌN»˜ˆ$žÉ†En`êžöM¶Á(eSBËÐFvnÅÄ£_ýæÍC#kø›VpšF¶îq™aãªdGÜö³!:¬ëÂ´¹ÀòX\‘è$O£LïÂÊ1Ã]'†µ«4Bƒ“Üµ<Š†êNž1=è!%Ã;¹:å"”Yä¦íû]š#è*ÙµÃŸ<’ÍhëJ[³fÃ˜Ýú!¯¾ÑšS¶;øç›7,¹û°©?7ý?oÓŸÒ!ÓÇï»ö§þyå¿l3I°¿×ÏôË>ØÜ–Âñæ9>µ_Ðç,‹yšlÓôÇ¦þ#hŸyÍÁn%rŽÊUðwfÛã¿6½¿‚é¡×¤É¯ø=É«ja[£?6õA[øÌk
=H—3Ó7t¡µÑ›ú 1|¦ÓÜTËÔ)iPÍz­ñ¦Ïò(Šfz9ˆ®w†Ð:bÇ	Ä/[Ô^JZyªƒWs÷ukY|µmx€D?Ù$ WYÈOñ³u‰dÉ‹QVræ£$¯ú²ƒÛeq$òOd2(Êl=‰üÝaT¦®Ó¿JªqŠ‡m¨`ûû It‘F^ÝÚ6	:yqœŽ·EÀõëAÇ‚dºd+‰š:%É#Ö½†Tv×—[›t9Â‘UØµIR+9`%–!›Àú2A<Ã¼6'*GlnrÄ&•²r¹ŽkÜzØ†$Ï‘8MŸUËÉArÝ+ç
­‡±÷_+%É†×¹'‡ÙT5`!´LütÄ—µ†öqMhüçÇ|ýÍÑóght¤(ó:;ÅF­u¯KmÊd_êÄºè"ÓPÑºœ$&q³ÆÇÉCci±9Û9ÈÜš‰Ö.mou÷]bèËÈ°¬²¨'±~-1;'¾‹4bªÏí™êDðI‘î$Kãð»µÄÚí`–õæ»];YYÕ)ãdµ}¹s4ÀH_ÉÎY‹?)µîªËrÁ[aC¦*òA2OðP>óQ¨RYÙ¬ÏB¶üE´I¼í­oœðeE6E?;wX¿¢ñ×…ƒÐeEÍYz–ŸòÔz5ŸÙç"Ü~Z®B!‰É¡Yhã¶òÀ¬µ@ù(CéZ-YÒä Ê9+kß^D6¶:—ÕêQà`½bqx?lÜ#ºœÐ‚aÅžÝjÜÛ3ÃM3ÊXíiÔ!7c:‘š¼w:Þ¸¦%œ-þ.”ÓªÓK6}cöŠÌð3Ì™=TMt$Õo°âUz¾UªB @^¦}¬3g©fÚOŠÃb‰9¿Õ	›ž¸he±³àÃ¾UŠ‚Ó<ú)ÚÖ²y_ÈP?…co,8Rªç(Õe¦o-\Âæ÷d™–C±ÂßýSü;Pœõ‘ø]¥ÒÇµäP®Óñ‘<ÍOJÌ?ŽeÂÏCkêàZ œ±ÕÁ«¾'`#÷‰êˆ1qŸô5íP]z§)ò*ZÙåµÌ—Õ‹½õß¼ÛŠ±-+)§Uƒª,¬§©^mKé¨^Gtg“:\ˆêN«–Ž|úˆ1é»¡M›zÓçNzdt‰Ë½©¶23çùC7$î1ašÇýTî|fÀQåbd~×šX^¿žÖ˜ž<E¯Q~P rJv‰¡¥Ÿ‡’,o\ ÏóÕ§Ô“>ùxûâlÚr;#—C¬]Äé¶müdþ„æij?`±óJ¦Uî&¹6D1¿ºù®ñhqA‡3ÿZ§â§1žrÈ|$7™U`V4:X™7/R<[4.S:94¥W­U:°x;•Y±| ‘¤U“|¾uÀà¥‹ÚÏw:ênÄóE3´V›Ÿtž÷Õ'âëé)õ\’4‰©™l`ñ+» íŠp/?mZ‚XÑ8­ì(‚pe!Uœé‰G³Á¸,fr¸^‚‡ýi†	˜óªfœæMË‰ŒOÄþc„’-kS±VF0™W}w²Št’o¶Oª… zÉ/û|Øu÷vª²ôÀuÈìÑ7ŽÕAŒÄÎ².ùŸ«ê“a×ˆJ1ß¸T´¹óªk…üšTãI¡’Öƒx.xV—ºXŸf‹2àU»HñºñÚâ¿?.³•F3=†çºz\oüØ\'ëzûÜ½ä@)g¸º´AÒŽ‹‡õñæ¦ÏûvªëÉ‰ë¸Äxê†®¾°W4±Oî`ŒÈj*²‹‹`[kÿ¡^³/ü*ƒù2(ÿËd¸$Ø¤Ž{’ „CMÃ†ÛF'Ÿëô­¾sªïÃzv®´óæéÕãÞ˜{KÙIu§¼bf´õ)sZsuÊÈ½¢:%ÏŽWÿÛòÃ%¥„­²œAgñ]soŸ¢»R´&:25×~C¨'\·r€VÞ<°Fac3|^MÒX)^C²ÈcÓ,EÏ§
 cÔó¯·Œkîq1O6n…È‘R›×pSZ)^¤¥¦ô¤Áþàr”ŠžHµû´=Ìí»ÚùÍƒƒ´VŽzq54Ó%§˜¡õašu v È»èVäW4rÁ~úê
º£©M ™`¼n˜¹š¢ôj¿×x3¢ûÖèðWµïLá}±œ]­Ïœ(¾^ùzø¢·ÙEtÁÄÖˆócE.[ByÖn¯#®ƒV\P£´0÷œï¤Âû^eÈ^Ò+ÄKêé4}¼íhÍÕ’l6ì.ŠnF^HÔè*‘aºþ—®ìðE«WñúHï+Ÿi±ï}é^lT‘ý3VI/’HM}òˆU‚×¡Ñš§ô¦VéG1Z½Õ`í4ÌŠý
î,«µ»¹”Ï6³hI¿·áZ¾eŸÁ	¡Æ@ ?A_ÝÆÍØñÂ@¸ê„æß—Ï}8çª™f2Ä?b¬NŒßiÈ ÷?wþÏæ“âåL³ÀyG+€«gå†“;{ë;:
w´ZžO·‘eÆÀ¦ÎŽ°JR°~Šõ¥ÞŠC‹réôm©>=k‚%¦v÷[kh=µÄ¯øËêH ƒUXæöïU5õhˆ’ÉA>§í¥¦³›Ü<ëésyëYù~=ÃC«j*Fñ+;NXYOŠGÄ®%ç·M\ÒWM­<3.Øï®ðC/9º-°ÊHÌ[“–ÛÛIÑËÀ\oðÃþ€úŠÉä$¥<+ú#¥<Ž.Æi1£KjØÌ‹¼å'½÷m™äWÉóZ©UÒ5ÿ.ù L«1Ý .t‡ždq ã€:ý»/\á  F±ÔíÐgÍgÅp†û¶/}¹	õ”¶FØOÈârïú®¯Ñfa›½q¨Æx,FkˆZ, žZL4«XÖŸËæÃÑÓâô´nQ”cÎ„_ÆY˜-gÇe:p÷9l9[È³UI¢ÇCÁz	ƒÑ.}m›kžM"oN„NX%ö€g—¡ª­S/‹‡ûi4ïÑ^P|õú¨‡ý,
‹&IxÉ• kÒ÷" •ÞH¸³á‘×ÂÊ˜Qh¢KU»ò)¤–}mh§–¯-9þXÊ7€^ÎIÄ a#-9#ï?“¢Ò(‚Õ±Ž˜#Å¨L§V®’pjƒqA1v"ävŒÈ²µv)€Ëë—Od{ø+ßr»^m5­=F²K‹öÖÃG†y<dÒè„ÙMÕ$#Aã0Ï:¶U¦óŽ‹‹¬™r8õ²Ì óÓ@£Áj—ŽÈøab3Pu¢Á²aŒþŠ¼c6Íµ?§ÇL®Õèƒ"×¤ºd˜9ÖQiÂE‘c)¢¤8Ðn|ùe®Z'$A¤Êo·©¨á²}—:›¥'t;èrp¸ÅÊ$¸Œ‹œÍÎßD¼s&•ç/‰r	§Å6‰ èê·ÂA¤“³\.Í²EšOV„=YSIí³á™u×ÿ!e•–3µm½
¹R¸Å$â\œ ÷'Ï"Äf‹®})·6ÅÉYk\è(CR!Až…Bw.j¨ÐÄ«5Â‡ˆ—‰oí{›˜FTa:›e“Àxa¯©òºÞ hxo¢ÉœßÇ”œQ)ªyZõâÇ¹nÍŒJO#*]À»Kèé™/«ÐÔ!NËubØ9-qâM¤ÂÀÿþ	½¤Pû²ÖÂN1©µ¬ÆÊŠ3ÌúsxÒüÙ¦I„Ú‘ùs'!ÕÍÎäfÝ;©0.\ñ»¦–X-S&6*lª›“Û+m»°Ý#^|æÈ´òÀÄœyçÊÓå$-“s‚ãušþèJ†Ê\ÀŒ½ø ]`z.±6Ó÷ŸöM@\£
Îèœ±ú4ÕnëµàÇÔ64áÜ,öÁ®7½ìðÈbE†Ð'îá"Bžs1$+[ØÏ­ª!@!rÆ2Ïû&‡OÜSÄ¡@<ÊNu71ódøÉ"Êý#2ì
œ#s(¢…a }¹RhŠRe&‘ ’ŠrÑ-z®¿¾±ÊÞBµA‘A”Å¶U›C”ý)yÀ7ð*¿Ûõ9 oWàK…3Ô7oŸ¦ÕBf~H•hŠwÀL¶%¥àás,-q]PÈpR4@Ó–ªm¾1÷{çàÓÿ—~’_ÿs^$à/ù½;þ'Æ^ã}ß5þçÏú·ÿóG“ïŽÿ¹qoóö5þç‡ø5à~zïÖí»w®ñ?ò¿þç¾û_Šÿyóþ ÿýþ½û÷¯÷ÿñkÀÿ$.h†ý\	­×ú±°?%‡¦:²D—ÛÛãÃ~^ëïÃ‚€¢yþ‡aÚÃTêã]j.dc 9(wgˆ…4,‹|ˆÿdã¸­mÎ¡‚¤ ›‰kHSSŒÁÙÐdz-ÓÙ© _â'™B\JwM¯ Eñ¨¬\8³Nše~Âæ“†.“6šžwÝD€x(ýÝW_|‡å¼:ªè´~µ$^ô ¢:ÃÇv´³%ëÅŒjhÓü_€ðIw2]:[¿öpxÈ[‰èý0¼:-‹åŒl·¶\N¬z•ä#‹¹õÛ‡@"ÂØCøÈgÏƒ¢œ°“>öäéïTÊn›~¸˜™ñËª–šö©¤/ªc• -ñ~,€œAÈR†×Ð‹)Ç¿r”OÝW@ª%]¶¸8ˆý—I5(0ƒ±ÂƒZ£ÐGNF
A†ÔŠGl„/¥îu’SÆ+¥ôÝ‡R<ÿ™ì2O^RGËž2YôÝ8õJ—|ñrJ»>/æKÝò‰öÉr2É0rYŒèÆG¥U…cºûj­’öFw3™§ezZ¦ó1ZªƒßV/”U“–ê”HÎ1(‹®P²rŠü|Žù s¹g©’YAÉ“‰ÞÚ›)
¡ÂTBêŒQØ$ÆY`ÕåŒé_¢4zâ¿¿˜Ãk¦Z©fßx+á¡OÖ„VkuÉèËL‚ys9-). a>L)ÛõÒb“kŒL:7êßIŸØ™
Ö°ŒÝÐÜdÆG†^ÑKAM;Ãxæ’¸YÓW×Ã®´ Æ˜*•fÚHHY…´€qÎ0>OñLÎ$*óÓñÂ2P‡› üÈ'Åm’qÊh20÷ÉÃÜ1)NCêì0Û<Õoˆ*¢.k&Ë)ðQòûG°”:ÆÐØA_ƒ|ÖI0b (¿“‘<e4;»°²1²I•:Ti/._¨ô…Dàinÿ«|ThÃŠ¢íºÛ]i¦ÇiÊÑ.+Nãu¬à §¼‚l¥/¾k\ë‰¯åhLE›:<f|~ô›î‚äX.“mÚáÏú*êV°S_t¬zÅ! t±ÿÚ+q°Ê˜„vÌ±`Íoh?ŸåÓåTkYäj8ó$¤©jf#c/â—ý¦«gÉ « ‡ùÜ&ÿ…ÏÿÆ<ë$_g'ð'sç·ª)³¢¡%¡T\·ÕdÄïN´ƒ›Þi‰~P[Yíß”¢ClNxÃWÅãåZWÃÆ­Ý×på&`Æ:#þ¼ª@>ëMÊ“ç@-ƒáuB^T}Ø?û2ÝoßþMÒæ§ê+k^M!ïÅ@£÷!ýI­¤ó\Z0OZ	‰”:qØ[‰º¬ò?/á-ˆ9"ô§Oo‚kÞ/ÓrxŽ·Eš3±öX^ÄqZ¹òA]÷Þr¾ëújRÞòM™¨C‰ÕQ#”'¨!<ÒG‘ÀÛ4+"JÆÅypÓË{ÿIæÎ5¬º“z)[{=P.þŒÛ£UØfÍðsn¸gR§¼\$maªm¸ºt±º‰]<LÏK„¬×]ÅF2ûª¯é4ð0[¤6ü =ÍáïXèAo†nû!iLê@
'ˆ_ô36½úÆ—‰‰½PßZuÉÎUÐO¦ç[â¼Ï|·i+¬ÉfÃ?_û¬W¦£z¦A‚Áãž=+f]õ¨öÁÚÆÝàðd›hP¬»oÔzM¥Iëš-§'Eë+Ú ¢Œò×ÐÔãÃø"ÛEÿŠ•…4F‚UkPDØ¦³×)ÞL‡Æøú¨qc®9ý…\ú,Ø¡*anrÙ;¾¬K>ÒåˆêOKfÚ,n’PYÑÙŽ¾nqè	ƒç!ræxÔºò)JÐt†éëÉ›¡ÞÜm×M¸Ur’|¢E¿O×
ú&éØ{ÔA?SZ™³ÅZ½Ñ;ºFi®æa!SNê_ÆIZ™m(Ëc¹~y…~žyv¦iþZ„q´yÇxAˆUàRzFL„‚Yeaf‚­ ÎM@¸Û¸Æ
8Ñ$Î5×ÕjÓýŒØ[Ä½”›ÂS4‚rB­[·ö2ãˆÈCKë¤HkløŒç!¹á^$„P`;&Ñ&IÈdÒ¦R&ÒÌîU6îÃ´|E†VY'„½äA¡Ó8Jwa(—¯»îÐîóIhêç{w†§¥Hç—šC› ×_ì%gºœLa¶5GY)%õÜ?¼„mUÅ¬—<F®Q<cË
:Úeö0^²Mg%_÷¨†*t1íøëí'Éö¶ýüË}<ô&Ä:›Át+£=VO
4 ,u’/—Àíš%yb£;ÐõMÉæjø}´"óS:GËÁ¸û­zä	ÈGD{ü2KÏà,ñÝÝEoåÞ¸Ê·—[Ðsx6ÄÌéKÿ}L{CÙFQ’“‰g•QNîÂ3d§ç“¢*æc§6©q®¶’‚³|ÝwÍçK!ö'f÷«UÐ›NÂƒD[X×Ô—édIW&„²c8¥´Agˆ0µd!¯š×®×Rï©%pP+Û¤4“:Ìº²ù˜K"å¶˜+Ÿu/ö)·‰qä}5¤xÂ êhõNùaó™äæMâä:PÔ>ÖÛAµ/AHÁ=1Žv5®4¦‡ý‘<ªø½MåC¶ù#Í¯Â´¬ÂcN°_7âBÆçV)a
ÝÒs–ÕfòZ4ñª¹V}ñ²¸(tÂŠ+î©/Ö}ÞUšÞ}˜Ã ®n5$%W?NOÖ÷³Ù2¿DxE`®¥‡é9A¹ìšgkæN<ä.B¤~‰¾·ñùzŒÊ]ª·t¹ŠˆÚólÀ†2Ë¢BÈkv}k'4Û£|´a`@\‡°¹»7CIÒp_Hl9ûVƒ&u3_×
ŠÇ^²ÍN
Øæ88§8PØ’GÐZÿÔãÚ}‹ƒäýÈ‘(-ë CGŽ¬IñàhŠÄVœ·DÃé³i%}à2üÊÖþ½hæ¿Ûß[Ø^%¦>ºt)5h1qR™—C‹èÊ|Ù)F ’^õEUŒ
O¼º€ó²œ~ÔT-¯0¿`·òŒÞôýÎ÷Úv¹ÀðÔz#S|ÑÜFlfOJ °Jƒ }(¯“_EBƒUFMšÆë©ã$¤ËhÜ> Ç
“îCÍªôÅ&+('ÙÂ~ÅOÜmOÇ ž÷S[.ÉƒZd}>ˆ…ÕsñbŸÑò™¾¡/¹ÎñÅ¼ k-_õZØÇÃŒu»ï¦Uµœªìþ¬:ïýí \ô\"Y-Ãc‰Ë°åÓ(tI/âC
ÊÞ0ëlý¢ïä·£Bf;> —ˆwµ³‰ÐÎ¶ùnþoR¼T„SÄ^Ã5‡‡ÐuÚT“Fér²À††Ë×ëŸ;$Ã7(	µÞœPLk¨5eÀqJï‚wŽÑ0§œòß>…>Â2ÂìAöˆókš†<h®hŸŽ~û4ÇÛBäd
§(£îÍeAÜfªºõeëoú¾â±£ý&ì÷Bîï5µ¿bO´V[¯­™KJ¥nk²ír&‘vnï.4’“ÈõZ¯AÛüê+[¬áŽ£h²ŠÉ‡êÉÅ¸žËôåƒ‡ßÅØ¯>–kþ^mQ>6‚XÂøä|´s¸w¼·³ý4y´»³w´÷ü^ðEf,h´³Þi¯ÉÓÓ¡lËøwd]™n¬]AahÌ¡h°ó¢©}!¼*õ1Ù£œû¨æ‘èÂCãKŽ;:û—Üü¾l&ÙX‚qåcí
öjÍøÒyˆ [T%·Â³K#à¯Tf<](T³b{•1†EDQÍ¾-àÆþ%ImÎ”4¯_šÔ§O# DMË±™TßW ñs4ŠßÊ¼«T-jÅ€-0 Î®Ü—›Ëh“gú’@¬F«/šˆo¡W"Xê²vL‰pÚb:fÖ|dP«låG¾
GLÉÌûôº__5éÓ¨ð
Óm@¨.ŸêÕ"uêƒxº¶ƒ8®R´‘Õ#`axB‘g—KÖ½ÐWVWÝŒ^	Îm…ýjÛÀkÀð‡y[ÈU×%±úÞ¼mÁ›ñtÈ¡ò n›ý4Ð¦ÕœoÛÂ—+áµùßž]x×W1\}Ûs	%/ÃSƒ†þ¾äj·Éë¸ùì`¼°M‡›‘Ã[+ôïÊª,9A§ÛÌoVÜ¯ò¯Ô£”/†säñDX¤I³¨#3”[û;fˆ`[„ 5b7 û'`¹JS•NøÑªZ—}gö¹«ï‘Ÿ×µæµú"V²Øª™0îfõvLhûÌl[È¡8ñãjµÅ5kEºãpÏú†ç:ÁÐ•jÔ$È-&ÿ“—õ·&[Ð£¯YwbeÈe|MÉÅ+µ`LÊìmbîd©!ë¥¯‰ÚæÛBãôußô8×UgOñy#P|(«,lø%‚ÊH¼“”
¥«…-ööÔzÈœã¦÷ÃÑÃã2Šu|©³RÇ¯•iÒâ°ôîlP^ÌãZsfß…â	?‘EuuêaÖ ¬_Pî^­ÚÛZ¿šþg]FÂúÁ­ƒBy¹Œ¤^ÌÕi[GU7ãTàê¡zŠçyÒ~AÆä
xcà^ôçübâðêòýe=$ŽrOŽÓåRÌõf¢ ¯m­–ˆ•¢rèå'ã¸ÛÐ„qõ»´¾ÀÞ['CÓB‹<“ÍóóáñùfÞ%OÍ»¨`9àl˜IšŒóÓqw‚F*Ž¡.îñ3ìIÅhY;K'=öÂ·í°œíý»‰aÜ	ÀiE”YÐŠ©ˆ…ìÁ çtÏ:02É:+ÚÓÆþó‡{Ow“Ýƒ½äh÷·/vŸíì={²å—î26Ø³ÚE ·j¬îæ(>Ä…;%mòC0ÆŽg×uÀPÌº»Ñµä|Ìƒ áã°ŒëPlô®oMôcÌAÊ–%Y²Ñ«ì„Mìl%îN¶yc‹ÅEÐf+ŠþŒÀ]CÊ©Ú©Ìš’åØoîk–‘QÜ£ŽÐòf{’²ÁÅ`bÓL´ÅP©¨ÒÃ{ÎnòÏ¶s¡tóú+¾ÉU)ø’Ý&vé÷·>‚†SÿQðíMÿÆØJ•DÜ&â3KT2æ+¹§¿q»É•Orvq¢‚ÙÇ¹µ˜É-ƒ²Ñ„_º=\ý*9(lþ¡D³ƒ†WÜD8¦‡F:Ö}×H¬0aD²½yƒ¥úìÉøö­ù›JŠ¼-³9|‘â™x,æh‘y°b´&Iæ’:ýª$}p’Ùu;¬8Ï1w€Y¹‰@xHD'±KÚÑñóÃß%‡ Ñöw÷wŸÕdÚ‘|Àø.X°eþ­ÕÕdA¤ƒI[-s”vts9âŒïË>êò¨jqZ{Äå/òÅz7ÿ8í”m@AÄUÄ–Õå‡™†xº{åz­åqS¤d†À}”[:iÏ\vrT>ƒ::Š{ŽnÆV|b?³k-.ÊœÆò‘p2út¼}{…ˆw"jƒòxDÖJ¡µð ®?Ð«§qùÝÕ
Ö6ÌPàP‡þÆoßvT¡½äµ§
Ê´.S¼Ã¹ïl‡ 8·÷l©&5º86ël£Ô¶cÊhéŽÓøËñ^ß›Eù(œ%·´µ—¿ñöíG^3§o4ßá¯á”[ÞD[6¾z±xøþ´º¿K¡’cÌäµV¶Â¸ã\Û* o­Ö”Þ_üv”/¸N:ËûšêÍ=÷,ÒîÊá„~#Z¸e¿ýÌD˜Õ¯ED2)ªÈ ·ëbŽSNc>g¥¹ÔÑµ¶¾çldHÞ´¸zAÄ¤¥D;©Ï­Õ¶æÁ8¼BæïÍ—“¨ycÇ”I¹ŒÜxÔ÷ß‡RÕ.t¼7yHq+.õ„6åÑÒEQ8?¿f¥”´smÆtD!¿(–|o8w(år¦öyÏaÀÍDŽ—ö‘¡J
†^(b8›Ç¨A ‰Göåe®×|«ŽHéÓy<ºóª?ð‹yÄ}‹€#¹-åL¤ ’~Ä¯Ÿ2D{×à"Aèn60N=ŸÁ\ô.Ù8lL”ï5b`+€Ûã!ÖÜ›
@ü£Ü'#¬YÆ¾w.ŒÒäx^ðŠZ„l%™¨¼Ò;ÚÊg-ò¡æX£q{•ÃÙ47g)lKKÚJÅÆ>é‚4Â‹+‘4êÒp“9}µßÅj&´^?”	]!þ+â:…/ì÷êÖkðø	ð[Û1¯ƒ5`®V‹v H}©[„ª{…”¸±jÖ ì3N—T!*ªù‘¨zf‡ÃJ\²2‚—‹¥ÝpùN»ƒ¢@÷æUiÈïi'V.ê«=²†Føè‰{pùMQÝ=zô%(ŒÊõ‹gå–ó_Œ1×¦æ·Û[¡
g“¹˜¾åEïuÔ‡b­Ygô>B©:Ñ«‰X‹û[Jm
¯„êõÔeª%ÜdÒ"¯Ì½Ì°Ø~Þ‡ÛV+Ù³¢D
éü‹ivÙ
3É7|3æ¿4vÞOá×ëÛ%ïíˆûx÷î;à?oÜÙ¸¿yÿøA~×øÏ?ëŸC}~ràÒõâ?oÜ½¿yëÿùCüâøÏ›÷6?ùôþÝküçŸüÏ®úõ÷÷ËÖ?®—`ÿ¿uÖÿÝ÷×%÷û™¯7ÿ6ÿÇ)šmFy6v%OÖ_ˆþîù?67îÝ¹Öÿ>ÈïZÿûYÿÜú¯åÿøÑäÀ»çÿ¸}cóZÿû¿ýosãÎ§÷¯óüôný¿¯Ýÿ²õ¿	Ï6Ãü?÷¯÷ÿóÓ)1ÔUCZ&ÈûÊDôkueõoÈ˜AÊÞJ¾à~œŽÙ|—n(¬Ê§¹»ªpü>çF’±_â+4ñ}ª´^ÐŸmžA‹BpÉ}ûò¨Ë†§ïCè^38`ØÁÆQ®åà“mr`|&	L°¸\¢wíÍ¥€Zu“çÞ ^˜,ÃîÉôl.rò ¾°(°yó¸…·öQš™RÞè-ÉÐlLÿ|“XmùiL“€„‰³¹ò[2ýïcR—lÑG'C$«*€÷$Ù"' •ù¼_ËmÒµ´
ßÍ
êÒGæF\ §+uÑÂVÐÍš½Z±ñÖMßvô}‹É—m¿ÜMž¿8>xqŒî°óN¨Y#2âE±,ÍL§lÐ=ºÓ¼Ko8)n^¸”7‰¹‘kžètå§ì™Î'ÙvøµK/“®Â®9ùC¹Ž7W^ó¿¦fÒy#üt³kU™ÊU¦å»âÆ.ê+BGÍ­¹^r5—w[¹Ðê	úO³³º?ìýô"©–§è.áœPv‚:æ{>²È«ÙßRÈ¾$JMÓDëkÓÀKì™Ñeø›WÅèpé'§ÈÈ÷a‘V­oAR¹iëÜj¤´»Òˆ87€¬\ßYžÇ¬H8C9úÑ5{·t¬w³sBQqd—ñqHÝ‰£ÃIÔ»SdkóãÏ¦zÞÀžñ K”,if
“H=HÞ\ãŽZ&Üƒ¨ØM“¹=|O³¼œ8¤Žs¢¦Ÿú¤LÚˆ$´~ˆñ+ób¸þ$[|³Ö‰zh—’ËY%˜ÃÈ)GAÈ(6tI·bµÇÊX2rGÝ˜H2™;|å÷ÐŽøE Ý¤ƒ+¯ý©M;}óù¥¤üÿÛûÖå6ŽdÍÿzŠMìêAêfIflx“i‹‘”%™¡À4‰&Ù€†Ð %åˆógÏœŸ±ï6O°°•YUY™ui€EylòÇŒ…®{eUeeå÷¥ßËÏ=¶·¢)ì½9ËÍ8Ž@á¬)UÅØuÌÉPwTîEýÆ±ËbO’ÚrëYA?tQW<„æMwÈ3L­buB 3ÆÏ±Q¼ƒ“¸qÈ†•iè™=— ZgI”rësÛP¢Þ©É—ö¬OJ-$z „GoÖóID(*Ïi“ØÎ>A>8§Jƒ!0Ž¾Ì¨<ã^®fªÛ¡‡‚0¬:Ô÷NY×“ØÔïlƒ w!à$ p%8ÈG®@g‡ˆ‚ÇåošuÓºlø’³kwn{AÄ˜c›ÖMÇó°$µd¤²ÎÌÎ—X¶e#tNWÝ
“°é[&làto²NŽ-º©‘ªêyƒX¥K\QYñ{âm;ôpdÔpÇ:pQ|u|z áùÑ-†Å «nY%zÖ÷ª#5æ4èÚøÃ|VŒî„-äªa18+GÕ@I„ØOºeµøÓžj@·š;°<üo(€†‘—ÑVà0lYØSKßÊ„ èÚ•ˆ¼=‘0UÁÓÕÁ.ÛA:åÀÊXJ²ö èø&±±ºÆ‡‘KÙöP³ûb4Xj´„°©KÙß†€×)J
ÞÒÏ©X¤¢Ìå%à,›ä=½q¢s¶TÎleý5Rh£léc>[æ´ô’/jçRö#—L»ª3•w¢Á›ÌºïM¦ž/;„èð-¦S4Í4À€T55@éÞ°<JÍ®u¼úBkùtîm#ÒÜVñáŒï¨)¬ûÙ?ÿë¿³×-ÆÇìó*Ð¤dG5ž!éÂ‹snØ€2««‹£†ÞÆp-·q+™ø«ÏØf}ÅÎŸ¾@ÑØCIb}Ý&9‹ñïVé0.v¬áEpµ®5z¡ss»½³¿±½Õ~¶”íºˆ•˜šuYÔšLÂ[6½˜9«Ë Z
K"%ÚÂ›µÑµÊãó&h'KlâüÔv¦Ô¼Ø¨: ^m¥ë•]ëÄìM©¾t–F—›ý(5åPL‡;h|ÖRkjµ8‹-šD»qØF8ü0²Ä‹•±Ž$	Î–Â9w×F_e€6÷ƒ®4C©5£Ÿp>zk5du|›ËËm†GKH|¢ÞåñÅŸA]jžfH]j+ˆüÜ¦ô]ŽòªûÕò×T`ç°k+åÚv&V·l-)¦<^eùnƒ}˜K­äf]5BGãoØ³"?ƒ>AÙŽ‘_­Ÿ—$¥ý˜¼ðåšÍ™ú¿
„áâ:ÎÏk³•Ü¹ÜâÍ»]ˆ@h7Úw9bø¹`¨+¯W¨­Ð ªÓê4å¤@ÝÜôCÆŒ2êÑá'eãâoë~±Ñ%‹¤7Ê»tqUÃ¼è«¹eS±£ª~:—XìDq’“¢´•r0Q×xpj¡¿§ÆakñN$á˜SúL=ë<ûçóöÏÈ—ˆz² ¢;˜È;û2‡„
r•­˜Ž©	—=¬ÐúK‚·âU}TLÙ®ˆŽÓ×ÇábEz´—(0%Úï-¢ˆ[-l"ËÜÓ¨4ìQæbcï¬Ä8ª¯æx	’ûƒ»¯XîŒxJ!ÄP^Ÿš"˜I ¼Iñ9ŠÖãhLÄ›E‘4GÖxÏ„…GØ´;Ó{Õ˜ŽG•¡‘˜&ä	£Å‹%áù´©Òä!f¦pM˜9¾ª•YCHù>¯Iváæ1
vt³{ËéC+peÁc\ugÄÞ…ýÉï£2Bd›Õ¾&wÔýÛß_|ë…7XÁ¸´Õ:åz®W;ïªÚâ}*ºòÕ,ñ8|
2l«s0OúV&u‡ª47„Å àu±=çy¸N~ÁHÑÙ`«Ã3ÙCÉiæ¤^€¹o9Â0n~¨´ï±iž_4Û¦‹‘föi²	Âµ–µÃ|ÁÔâ”vKˆ?Þ·Sô÷¿ÿ½_¨–zM`°†lÕMßÁ\¯–h¿Â›¬ÕúlùÀ\¬ÂgUYx“®ÐÝË³»”+˜rÕ¦¤ë¹{”dG…Ë¶ŠÙÖl6zËK¾Þ¹¬k˜u=RcÜxår®cÎ§6gMÈFß¬î²<Å,ß_ãY§áô2zùwŽtå{ÈóñuQÌ6øëtb u®­êcöÃÁ°Z"s37“©ÈeÛÀþ@ÿþÿýã…gPeÍûÑ5ïÙÁn³™õ—š·yà›*ñvIŸyMr›~ØÂîÕQK–+dÓnÔý%[ŽZ†K¸	w.ì>‹WULÃú¼ãúüü 0,ØëOö{Õ{ãå„~ïÈP]ÚåÕÐeŽ­sÑ8wñß{N‘ÔU³¶î¹¶îÛ*ßåÔFRRÅYüÆË~¡j‹«añkÒç…¢ò“kÊËHïÍÍ ³÷7^FlýökÝ§¿p…o{?BÆWÚlNÚk×+—õõ¯Þ-ùòøŠÊüù©Ç„vÁŠ}-ü™þý³«¦ÝF©5"(
xã¥‡Š–—üG€sºäí¶Þ—oÑOjß]€Ÿîl“cêÔ¾E™}\~ä¹Ïò8w#t²¯Íb…Lk‘ŠP-«±9x5òÎÖ²®ó¬óZ¢¯Õau6+¯.xqp5R¾z|®ú°¼¬v¿^oéÏßÞ][ûö®÷uÓ|l¯®>Y{ä}Üjú¸Ýôq·é£mÐúúÚÃåo¼+M×š>®7}|J—­Üó>>·ï®=z²â}ÜoúøÚ|\]mß]]õ>*¡²*&ÈFËéœˆ—00WuÆxÖ8Neëi‚ï’zG2v<I‡ÔÕQï>×Ò¤JGeïH&L€wHÕVu:¢NY·€Œ)Wåu+}±áZ¥ƒ(QkÐ…'Êwçbî¸Þe`—kgqlÜÑX^eEGS²íÙœj0’æn›–$ÝKwiÑF8»¢²½¨%Ç`YÄ÷—ÀõO]â¹ëÁ¼~A2g5£hâ.wš,­e
œm-èU<<ïžË·>Ï×Îk£P­LƒHJ8´™&Q+P?¨¶ì„ú«»Í0ï5áº†,7fD,wM0&Ò›Ë´`ò!1ÒõË5!Ñ{_s'&¶Ç†Á)È·£»öÔ¦xš¸i‰Qd¢ôçÄ—¨ù“U+PŒé†n3S+öúu»F:1ðjAñ²¾äÎmÎwº9¶>lŽRn·Nn]µØs¬–[µ>„ë•¡Ø“FŸvô ![—¹Í›&PÝ¶LÕQc
tôÙ^úÍ'ÄöÉÍÅòå¦Mì2“[­%,–mÂS—ÚKá¥š?ò«Ÿt}Â˜)õÛ…Û_ÖÿŸá?ÕÎ+.é@ýYOÀ>|ðèÿq-7øÏ?ô_þóÊöËã?"þûÿùåÿâøÏ{÷=ùæ›G7øÏßý_€ÿ¼òÓÚúøðácýß¿ÿàÁÍù	ügL
nY¨¹–ypOçË›kEõþVº"à¥Ì'¡Ì x(YSÕ&„ÃJÝ‘ð0¥R’ç ÍYš|õ¥œÂÎeÌ{BŽcB7´¶Y³œ(Œ/'Ü)—7ón¶YŒO«®ƒÊ®Ýš
þlŒ‹øÑvÁ|!÷Ý~i¢^Øè! AÕ	n£¸Æ€ŸðÞ¸$ÚÑé–5>ÇÚW[ó’}ØÏ»­J]
du¬|¿˜nöˆñê¼¯™ÿW &EDêQ/¯kâ’lð[³Ôè"%2âƒM5ã}
ß,†£¦‹Ë³þs/8Åyö|•‚tÿÞBÖV·B¸Ci‰`¿ËæÎêì}qÈt¯¯÷²Z@r”E&¼à!‚²§]IœTVƒâ;*áƒÛoóèíêUÕ[¤®Ù}\x°&Ñ”_×ËÂB`LšM#/…ŽuYõª“s$ÞK‡²†ÃÝ-ñMwL’ŽõŠœ-mÂÏÜ[k/;:^H§½³#`åáÈ³|k¯6öö7¶žŠÌË£ê}23_õü©üY{}{w³³¹ñt·¾°³Á8£_08ŽÑî€ŒÊJx¹¶ÜÙß6YBrµm@~#"ËI4já–\†!n¤Ú½¤s	_²v59àóV-ábnÐ]=$4vØžÞBÃìr³ÛlfoWŸ	a…yzc(ei‡ØÙm½ç»	'‘kõ–öÏD‹èûLÍq¶w›-R·’g NT+Òt"ŒºAÕ*Gk\µ¬_Èa-ëÇÜ†Egƒô¨u“½ÜÞýqýÙöËly·½µò½Í©²12»øPMÆEº&áRfÍw'c1õLvæEMÈÆxh8gÖt=HiD¶×Cä`ÙÑ_l@y¶ð™ÙI[ˆu'¤J ø(C,H®Š[×ƒÜ˜…ËŠ³¼7‘ûåÃmª£²†ØùxT~ Tß,d{¾²3‚¸Àê¿º²ÀGêXA&÷bÒõß2£9Ã¾ ŠnˆU0Òl™S+hz)å½âV\<Í®è†pÏ8ôe8Šø×y[DHf·F~‡@¿¡Åý (‰|å¤’Î@(CJ~|ñþ¥šŒÅ9÷ú
#K$@ÜíìPi›§ðXÏ˜(rÂ¢‚HÓÿpž³ºõ¼u?í(Mìugqô;©O’³N=Jc£¡ îîÇîEL yõãÒ¥¶@)lyˆ”p"Å:›Â}ŠÔÅÑŒÍÐ¼ó§U.$N°’"òØöÐ0š‡O){J‚ô¿î[, ×6)Üa&f !ÎD/?÷^÷x%SÂB4ø]Ç7ˆ±Q[xeæ€¶Úí¬§t“Ò4›tb¦ˆ¢nŠéDZ˜ìw¼¶ÒSz(—Ñt-¨aòF*_åîLõ?&ƒ6gôÄ^™Œðv#0r«Ó±¸6ŠGäøUGµ„ÉxþÃ'[ù¤[ºÂÕ‘Œ¡1
é#pq5 [Žcm|¼@[o98S_8@áÉ8Ã[gjïôìªÁÁM3 M)vo/„“¶ºšäÝ~>¼•\»H.yŠCêÓõ}]Ùí«³É›OWfË–Ù –ÆF±eŽ·…gtŠÈ¢_o¼ök‰Ž?Ò'“šaáöî’ìÀºú<*ÞÖÖ}¥8ô„·õÁ×c“5rîgÒÂ¤?ZyÊ»zWÐW®¯â-ôx°?z§tŽ(yƒRSßrynØôøé\œU½É¥ï(†ˆ2Ï|FÏ&V˜²Q¢œàÙ&4Ó´ñ8ã®ÅÏ–9«rè®¯ê¶bh÷Ì–¶Î°*–ùé(ïN´´r LäÜ…î+	2Ç²|T¤ôJ¾¥ˆ1ì|æªÓ­+Û››Û[î4]ÙÞR'í´üñân¤ª	2.w÷µÑ™…§ˆúQm±£nˆµ?Ÿ9h{wªˆ„,`ÎŠOUO'¬™†’q‘§¥È­ôT]DòÖ™·¹Ãù(˜Þ9‘òN0Ž.IÌ¾†`ÉjÖ~ŒTj\ëÓÑ¯Žà7YÄæ(DkLü‰f© [¡îÏG‘]º%ØßÒ}É$KMØÌýóa±‡ï(™/?h³¡ãã¡Õtg†ñ«šXÎÜASpž2PúlKÀd,:¬Hív˜´OXËCÑ-Wn›Ú°W®›¶8×Oßä=žÕï=±¥ƒ¤»Àx 6lÓý¤–'”w9é•‡£\ µ·L´f}A™kïldG=ÆÌa_Ï*¼+íNU«ÂÞ9¨½B+ØX\Yu1¶ÆUÕ“"ÈÞàöœØø–ˆµœ–£nk¨T’s”Ý3zû4BŸ°µ¢} H21ôý)	^©¨¨ÆSe—X¾a\Ï3þ‡1aZE$<¸ýU£“| —š~ËQ·šAÞ×ØITå=IÛDm/;$K.ÍˆyU*É¢a‰ŠìmµíSu¯ð k±ˆtjbîŒz6Å”›´C]D¿KM»ö¾—=¤JÌ#Íõ»¼E4™†gà…löØÑæ‚eFfzßH87”ø”•‹´Ïó4Ÿ÷IîÄ.žæ4ÒáZ¡‡	Š¶{	%í‰ î6%“)äz¥ßZsÈ2Ú¤ÖÅœc?ao0ö6^ˆjû¢ÂZ8m›@Ë[Z²às\¨Hæø±Æš¦Õ™ËÚ„Sta8Xzˆ#‚	lñíGmæ‹k]„K‰‹\_7ðv8Þ1.M«?C†vŽQGó^Ï/!.Î«?^­].A/Åu899ÑäÐ¶TYZHÙ²ŠmUâ´S«Â§žtØUc¶G¯€´ü)¤œQzHÚ0T¬k„G
š2È•¹\4>2ä PDìñLñŽ”+*£V÷;8¥Ú…QÀ3Àk†6V¾‹ØÙççfó¡ÌTUûÀ¾“Þ`ÝÀ“zÌ^üXE£™z2Ä#Ô)QÕÆB!ôëqd™õðd‹æŸA‚±\Ÿwµœ]d­Jt¨UªáCƒ8‡÷$k”,QTD Wù÷¨dZD*ø<›Auø‹†³
µ('×ù–Y@_J[fØCYps}^Ü³Æ<wØ‡þª9mCãªé
÷%ç£j¢²×§U…û'6EžÉ°Ú~r(ÇFð67e_4ºz¬¬&ÑnÞÂ.yâÚ
gQêÝü‘+"Ò]Xë@Dæ^Ú„1qÛªíÃ9¢Q‡¦ì„aw¶ùy£'Þ”TR¥žFEb×È‹9)¶rP÷òä„ØpŒ¤E®”;Q¢½–ØË+/ê„Ð§IÉLµc—9‰ƒ‚’·ÄÙµ¼âYtJTÓÎ–­æ`ySNëÒód75‡•¡‘Ð¹â×´9ÖGù1 ÷ôÛÎÑiUƒ´ ¿Áºv$ŸKåùÑ­n9¯Áá@»Ãa—ÎNâOeÔÔÂ† ÉÔìÙCRê¤<h”‹5…œDŽLÉ§&²‚‰àAä?câ•:J¥Oq‹  S) }'jÏïÚô§PZ¬LH²šþŸÿåžŒ4Ñ“Ìó¡ÑYäáŠ†^Éˆ^†Õ˜mÙYÙ½ÔV$››ñ}ã˜žö=íñ°¿ÉVpÒ!=ErßÙ­=³^…LÅºFÿ±‹3Ž‡°]oRþßÿýßÿiøf…?|-O#™Þ¾íu½Ó'±1?zÞùc.“&fQºõ™¤Oš`„Ö’>YKºÚ¬ŒÇ{ÀøtaÓmáH0r·ýj–u»Ú>f«´öÈÓÈxzlQ×¬·/`í€~†æ·2—j¡wºÙú{´Kå{Y:ÇÙÓƒ—ÚiÔ4Á>C¿	û«©ª¾?€³Å›ˆGá”mPJ±ÂõSe¤|ÍgõÃÁ{¼£Wñ°Cðt°fo+3V£É¯ž±¡
ËÖlW›šMÃMhzp6¥ßž:µO2ñü¨SÓ¿ŸyÿÞôþMÿaÙ Ø¥Z¿L¬³—™€Š„ÞŸWIy÷(ž²çJqt¶K¯å†ÇIô“}±Ï.¹¡y:À=uÛí©0äUS¶OÍ”»Ÿ×MÚôB´€ôîX·^h–§»‹hUSö’¡÷UxCd5Ef^Ó½¼lâÙYm"Äi¤µÙh¢˜ù±éãVsÍvü£K59Ô{ëmZìùøÔ¹¯ÃŸÙôR§/Å rD¹âÄÖ–i¶ ½²g-s¥ê÷­˜ÈâÌjÑ‹@·_-•Zê´8i	ªlfì‰B1¤·Y
Qº²1¥´ÅÛx€ø¤>R;Î‘%•f«
Ý†À¥æ¥dhv–ûÅ©9>œÔå@³ ;†W°J,ø‚,e·Ó¨€ÛþT5"?’Ãð=ð™D¼ù‚¦£%œüä%Ù	O^‚M•#z¤tß£¾–A·›Ð%É^sÜ‘	!"§“×ú=¥î©cO¼ézIö}5\S5úãäðuÍ7L?éaQ1Á$P.ÉîÓîàaënûÉ,ÀŠ€U^
4³"òÑ(M@L¨N"‰²¬4Ýß8!5ø³jèNá?¯„C‹8ÿAü˜ÎÑä°&¤5`§4÷ºXÔ>|DpÔÛ,Ÿ8³d%|q³è–“~2¦4Q>,Ån±¸‡j2¸cAÀH•÷™aè]Ô—öXŽ¸W•Ê;ÕÇÇ–€ÿ7¯™Ž^#—S%È2UõÞ^vXÿ1Á+ç’ØXl4ÒiCŒY>ŒÕÎQ—“×“^uˆ^ªÝSG	ûÝÒýn·PËÅ´‚!Rùí#;¾¾šƒ*PÇ0Ç¾l‰¡3Œ/oì4À%…N"óKô}!{€(ÚÛ¬¬ëœÿƒu)‚@¿™Ú¡y…«üòsa£Wy¼‹ôI8U¤Þ‹±iYÂP¯OÂ;‹4¶rŠÍƒÕÉý"NÛ7X¢©æŠÛI>¡Q?¶¦(«b;ôª’ ¥ìâ‚gýõW>6™úúgŒÆÇõ)J³£mxv”† Áà#Ã™›³ƒqX^È˜˜ÀòéH”*b×Jõk±<Žw6¢:%{œâ7ˆô—€/tr-âCë/¼¾ºKxöÚë¨Ü‘8ÕxL9!	gÅî-®+{f¡Ô EvW!É£A³ÆáMÚ‹Dzÿè`ù€4`ÕÜ²õüµ•—nÇú7"Ù4š	²ËöÃ7™.Ü
·;d$„íÆ*&já`‰T;Úùú 
7Na¬ë¾­²øž¡,¹µ·’	ÒÛ3‰ö¥æqJùµh£rÞ×¦z36úÉœºKƒòiænó{“~?‡›Ä—°¶X3LJÞ×‘«S]¿þšÑ3˜£SÝ7 H
öÙ>lÝ½ð'Á™<êÐ`,<ºÑx\ÿ	‰E&èÖ±AÐôÉQî˜ùinyO«Q599ígËv$	ñAI‰™GÀ`Û;œ‹Ï…{wühžÂ?AœèR46ÞÒÄ•òÉß­"ŒR¯Ht‰¯‹Q¡é½ä‰,Ñ£ôA<iÌµ? #ûä é*#–Ýûqþ¶8EÒÏÅcc°³9€Z	ÕãÀc[Ñ;÷ÕCu3N.,Ùá9¯S(¬FâéñFšKX«é0W\oÓRM>•F\ôÔœŒÀì0ª›é×æmºª¿ÿg„káKòEù?ïß}xÃÿu-7üŸè¿þÏ+Û¦®ÿ»½õÿàñÃ»7üŸ×ñwÿÛÿçýÇ÷ž<ùæ†þó÷ÿð^ùé?mý?¸ÿèž¿þïß½{ïæü¿Ž¿ÿg(·<öÏˆ·Ë_<Kƒs1šN*X?M¥@hBKDâ™Ð–6gÁÄgµ@ÖÞ‰Sy’%šÂØ{yeà„hy à(óÎÅÍgàrÄŸö’Òêçm5…ùÓü ŸüÌÆêïRõÏìô€aØßf¤ü,»  <–ôŠ³Á«LÖsçV{T“¤Ÿ|$#Œ0/lC*š•ÇšK³”´‘ÒÀ;wBÝÜS~-e;$¦Hžþeœ@¥)1lýÇOM4ú.$m}.=hËñ8äÞ£)†ë!†Z´”ð"^u®!è}	æ.çpRå½:H¯ÚŒÉùÃ˜ßª' \üNúpóiï¥<*g^À29;D'B;">§ˆšŽS¹"KƒP>Å8¼/ÏBÂ;Ž««sT7LJqªäkHa€‘@Ûƒî¨*…o0\[¢È=µ_Ù§;naI6YÈ%û°q£ý1 š‘C%¨=':È²„±¹÷Æ–æ-l˜©6¶ÈÛ±Å™7Èâ¨–Xúò³\/,2uÈ¬æ#ÄN¨‰<2â­êé¢àwˆ–mŽ¬E,*šÂ¾«ã›ë‘Ž1×¥åÇ¢yÌÁæ¸‹¢ÓèÌê°3ëóXÃ¢E+”5têâ#èOÃ´3ù0Õ·ø)Ü€è6’ÇŽoó~³ô¹‹Ó,û€g$Á‰*˜N®rp<ÊÙë+ˆÄ—4Ñ‡!H¨¯Žl·ß¾®!©‰Åšf?¤‡:GkÖ´¡—c'
!¹jÑi¥#äu­œ¾ÓDqÙÅjz³F•¨2øÓ‰n47õï‹¢›ÌÝYsÝç7»í-jK<›…âcB#N¹~8Î•Â¿vTi wBâ78ˆKòbcñÅ+µÿ)&h‹'X	Ï=>„!0.;=.ºQ&ÚÙä–²v„2åm›PÆd›lG»W1–‘8M®oiuÎñçnG=‘D—ZíÆ2îšˆÜú&Ãgh”w‹Vu|\›]G¨	.Ý®$qÓÌIÄøÅ´ú$8F¬®F^	D®·61ãï×gjAi|3ÌjJiò±À–+0¦Ng•ÝÞðv›ÒOÁùúˆMŒ/Ò°¡âM<B£d§×õ#u|më'ÇøâåXRlp¶ó¾ÊžãÑfŽè)S~%‹Ý/5˜ôY¦29í3¯}ÎŽv©yÒ™ùt.?«VWÀC4›‹{2ÖwÄrÔŽ¡Ù\à*Ò=-Æ¯²¹&wP‘ÜìS£l.ôe	Eß„nœîà.¸k"eÃÛûø³öÒÌæš4kÉ¥ƒÎ™ÅŸ‹øfÞ‘‚'4šK§ðMZxrÛ$kæÔíF7qF‘ÀÇ‚ z6º@ÞM‡½I^"S5ŸYHÆÜä•Éí@œ ¢d´ÎA-	S5{7ª¤»'Â‰HF~JÀ«/3ØŽf˜½(BŒDñSŽ müÕj ñ/òK5sbæ7_·¿-}Õ£¿…Ø2¸“tšRÑEU]-ÖI#«ãGäðD†×pÎ®8…Pc
ž_Üµm!xªL‰›úl<4âSY›HùÜ\)£¸)}>íâeÙ…(I\vÇ2mÇ¤(EWÕXDLˆfØrèò=…÷BTÝ2UO?wèFä±K†*Ge1<Ík» jb\Âëpí•§a´Å–ó[RÄ¶Œ>rØùNiüÇP#&·;Á?F}T¨Ë:^{(¿†Æù§.»¡L›f®/Û´x/ÉØvÏÃ
ÊxA¼é:î¦Ö.¿@ž¢ÀNó@¢z“ã‰çQù³[¬ð5L\”¼»qd²­_­Ø‡>Œq²µhÿÇ\mÆ+ßˆÃÌ#ÄË›ŽËÔUiÎ‘/þ?M£®¸gÂ V6¶)Éý…©<A$†4™¥‚pIfÓx[½­Žõ+N9ªÇsÆ­ëáªØOµiÂ
Hœ¦«p€` ª@–§öyÎ§ŒpQõff§HRðú’O5[@›…K©ñáOÝÒû7ýÇSÃUáÜ…WX€¬°Õ–±‚Ä•Yg7Ñ–—ä|øá‚[rl³	øAÓ„T³Ìâ&h+p/ñ!6¼\¯‹úcöÌµjWìK‘&i"‰ÍÏ+£è²!¹ÄG£vÌ¶¬…Á‡.DÆIçå:÷Çlû@\ãg(…þcËðSyR5Xþ°$Ë]õ<i¦¯4f“Š1XxŒ1ª	Kd±!’]}Ô…{ì€ÚÅ£:2H†›à¢mÜÜÙTþD²õò ò×…7rlÐ_ê:½¼(a¯bœ5V”“”¯š(/ž5Q^l5Q^l7}Üiúø<äÃðù$HÅa²=TìiyrÚaù	àuaÃ³ÚµŸªs@5¥¢o¿Ù‹‹%PêÂIâ(h.·Ž‰Žs°ìüCÙŸôõÒ¢ÕK}âÃžE``uLt 2DRÒ%ƒÂx¯:kðR€iè§h%ò'“Ü¡ûOª
ê/ìÊý}‘ŸÉGH„Ñ<Å”ê´ÁMÙÐ«'xêÒSÀyÓÓPß{OÔŒv,°m‚m{ÃþK~–k±Ž{´7½Uº;¨Äªbó®î^ä3à<á¹­Œ“ºÂ÷Åá£Ðû•ç/ã“P¨Ÿ”G¶¤1¼buð‹ƒúk,olMcj07ÆŒÛ(d¶, šê¨ “—£Ž~y…r€­`gRŸ¶´›èœã‹Â¬±àq5®Æç Xe_ÏkíŠƒ®KùèmŽ:nüoé%âÙÉƒÑ7«Áé_Œy€~ËØÃÁ®ö‰ÀhKJG'û¤Ôïnyd…ƒƒº"7ÎÎ’å“f‘ÄehG-º¯9"6ÞoŽ‹‘W'8ÁÕùq¥ØÁfßÝÓ¤×[dKH4´AÝ$– †GÜh%µ~îÂ¬ÑFÂ°:¿%»(YAMœÚøÒ­c_zÆX¿¤”ë	Ÿ1µšŠšÄðë1„À#7î„nY»j%ËÂl"ÔµÞKYÞ=ƒm…D¿ìv{Åû ’	ò…,kKÞÐ(F¼@w|ÒÌN 4½Yu?ï¹Ìœ
b¦‰""õƒ¤”pîð¶Øgº%1¼±àŸ©J-ûåX_£ð}á²7®˜Ë†»×‰{AÈé:ˆžÇ%JC<:JQlˆƒûãÜÊmîøæŠ‰ÙqÌÛèb™»—…ÇòGHžšacÉ)6Œ•ðdzVwccü<2»Àó3¯5 Þ³}x”J#»w¤éuM¬O7¸V‰WØ"U2ì©8ðÃ¯¿.^\ôóö_”Y(ð^	òÈn(ÆüÌ=…†/s”[œw¼Ÿc\jte\aÏ¤Ä+ã$þù–$€MøâBÙ† î]ëô€RA$öW¿³[H
ÏïæA˜µ§&¼&DjdÀ|ñèï¡…Ã/Q7g…€ûÇ»K“XXÂ9À[_ØnÙ× ‚$qÃtº6ID¼˜ˆð‘?5!³ñ-Äaý)™ˆƒú§u Å· ß@Ûác%þŸOô`¬¤nt7b­C—„ÏðÕÓ93}Ÿ‰ú†‰^3›¯ù?4ÎãMF^‚MOLŒÐ˜)^¬mf³l¢!¼H‚ÇA)÷ì¹×?ý±i×#¡„ÛxèY–‡€C$j&u€}²Ž²G¸ÎÌ`žt¯é*P24ñ@}{÷üUÆ+¶Ù“ÐÜÚÅ µ¥$§¹úìÉâ½»|TÉøaMØY®ÆGuÃIŒÛ(xáˆ”\šõq W:Å±uÆ^b¢n¸[úyW¼æ~	÷©ÕÔõz‚I ”Ôyk	 zÈQíÚ(ƒòNMÌÀÉƒÀâo\™,ˆ¦4›¥¢ûÕð_ÿï 5-þ þé0ÀËãÿÜ}tƒÿ»ž¿üÿú¯ÿeûÀÔõï®·þ>ºûøÿîFñÿ?yüèÑÀïþ/Àÿ_ùé?ÿ÷ÁýßWéoÎÿëøKàÿRpË’ 0~qaCb>ì©õVœ ~Iù1!ÝS)Õ!¥ÈYÇ¥¯ð:æQêû¤mï,JîFbéÜçE=3%/Ùæz6¯/ê ®ëA2nÁ…äÈ#W/ÇàFó–3^-eÞÈ~
C û ‚W€¥Ð?ØG¤&Æ ã1¦-¼ÉHD‡£²8v>@šo9ïuÐC‰ûZSýFÕ‡,`– .ñêÎ¯®F‚\¥ “œ÷Í8ÝÖ‚g]ýé’ŒM$¨‰e Mð@të£|¨¤@ÍÜ|¹ÁxžÍt6Èe‡Åi~VV£…l¯ýÓZ¶ýbçÅ¾ºàWÃsk»ôäÒÀìñÃ¿ÕpI¬³c¼^.Ü¾%ÇÛ÷Ð£aéíÅÀ{ó1©eÖÖX]¦½aÓ•µME`gwU Ä:”y·²,æ]Ú0atLŸŒfùiƒ—ò–ŽpµŸå–í>ÒØ€Û1ûIg+$ÑH€¹#fÙ÷Íü<«'''àÎPyæ%Y–Ë
ÊzðocbDAžÁ‘É‡–~IH•¶¶ôËuL¾bƒ1u±Ã’‰-õœG’n\é&#\Y}¹Û7ßÑäkãµÙ, ÆR¨m%¶Fdñ]UKŒÛö-§öq`®îÓ„ÙÝ+kã[c>»±Ùd¿'¤Al&Âõ›í*i¡IÂÖ‘ihN”öjá°|‘¾Áz˜eµï ›üàmgN ÒâlÑ Èîð-ÐÉGM—?6ï§‰Lm¨c?{¾ûÁ²K–dí½V“ŠÆTS9~ÆM0·ý²½·cuÅýj˜Ý»«ÆÍ4Ðe‰¸÷c™>zpêxú]ýÜs™\xä5‡<õàøsçrƒÉWbm˜s¢î¨
::x‹¯÷l»,ö\©-³ÎÇ‹/y˜–¿•á‚€3_»®ÃyQ®Ç§†ÎCF®Ïìi©úÖë£ýh\‚-¼Žm/TttZ½í•¤„†‡°*•Ø\Œ¾ÅDðgÌ'u¡ÀH™>ºMbrÖ‚ÇÆÁ9ÕŒÃY>*«IíŽÊÓ9îåjººì»¥aXuh ::ˆQ8ÿ;ÛèsQ›(GóªJzÐ¯0%g¹£»ÁFé·öÞ\ë¦uÙ&§Xlæ"J¯3Às²OïEpbúDì6ôÜuÑ¸t£6,ñ¸·ÅÛ› >ÿfƒáqQú†lÕäð¶’-uÃe›`äŒýçHF¯Ì 8êkw2–ÓF¹-Ìò½5ˆ`ó®À*!îäHó=Ÿã£…;Ñ¥ˆöç6‹ñ¨2þK£y¥¡–Ã!ü‡_”iX¹½‡rdø¨¢Z¬:µKúõ4W[Ù$‚…A@!HUðt!26¶ÙtÊ•¿”ÔíAÑñý0xlÜ¸ðm£â“µ— Æ5,HZhØÔ¥ìoÃ
vÓšø·ô³^^)}Ì”¹¼Ð“¼·”­Žò³¥rfc(ë¯‘B@­`÷ç°"«yÉmÀ]ú‘£]ûæ5ØŒ»öaÓÑZÙdÖ	„!EÎªFI]¾Åt¦™ª2€Î­uÔŠ>µiŠay”š]£rxQŽÎzb/ÙÛ4¶©9 \QyGMaÝÏþù_ÿý»n|dh Ïêó*tØ3j¬ñzÃ2ö©àl&oÂ€esÆBa|eÅ&–¥‰À­D¾†÷øÛJfŽÇ·q™ø«Ï˜w}õÆÑb€nGc%‰YôÕ ä,Æ¿ÛÛ‚ð@e‡Þ ßçàŽˆ9£7A7·Û;ûÛ[ígKQÁ rj%CãÅÜ°A3éÅÌñØX’T:mTVÊOj¢ŽÏ39Q)øß­rÕvºÔäàúV³¸š
{Oú²<q£O¤ð0À}ÆIL-±Õâ,¶†=Àõ`Á;ˆA×ƒ…‘;ŒYëU2d&~Ð%^enZþLéZºÐ,¥Ö‰7óÑ[«a«cÜÜ€ngïa{·bŸ¸wy|…5L†¿Ô.?o³æˆ.Ç†Uf&úy»ažßå(Îº›­pÝÅlïcOÜÚe¹òž‰mÀ÷nm5¦<.(å¸f‚[¶Ñ™³®«£q·îY‘ŸõÀêß¨¨•lpájcîÇdˆ/iÐÌpkAX­E†!vòóÚì9w.·ÀMø8»#¿Ë;ÇêºyèH.-&l»u…ö
µÑOØsuöòžò îN cFõñsµqohëÎ±!–ÖOo¼wé’ãê‡ÒëWæ®, -ÐQÆÈUÄáOš‹RpÊÁ¤è€rÁ4I˜ÜÒ¿ƒñ+Ôâ$P~6§T
6ìŸÏÛw°í  ¾d²zËòv~“um,´"ï°[1S³4.{X¡©´Óp4ŒŠ)›jã’tG`±¬êí%
Ì–ö{Kßâ6›¨ãa?.»e™K‹½ÛbÍ ïOr§p¦uU-Xô5ªrÍ+½/¯OM¾Á!¼*ñ‰ŠVF |nðûÑ[¯]šÃõÀ3•á½{Ú]‹éËj`Õµ¶`Öv® aK$ŒÎ/–$èÓæ«}<¦K²^Î;˜k^Æ$R¾Ï0n,£`ƒ7{³·¦Ž ¬—Ÿ&)s4u‹¡Ò¤æ ´Á¥JT…C¹Ã?bñF,äüS+6ÐŠpùZ	0.¥ú”,º¢¬›}pÇv(JJÿá'|Aý†ª¹C´Ð15~‚KH1oq¥;½ü\ðÅ¥ˆµ4™8bì«ršð]£yÊ‹¼J×€¡ÒãÇ¦™¡>`q˜Æ¥–2AK]Ø[y9²§j8:»ÂZ ŽÑdº„+¹¦Ò´„/ŸÍ!DÀ9cX	s³Ÿ†úˆºüyÖlÙ![µ)É>àÞTÙÁã²iR‡5›^!“ïŽ>ÝÃz¤Æ¸ÁÌå4Ä6§5ü/eþ€Ëb(#.„‹>YÒá,4w †¿ÿÞaè7øKzb ¿'ÔþÃj‰LãÜ„M¶*—ÍÐMÐ¿‘""ûñÂ³û²æýÈI$v›­Á6oó jBÅåáÒ?óÚå6ü°…}¬£ö4Wˆf‚Ø>¨ûÖ^$Ô§€âÂîÚxWÆ4¬ã;®ãÏó†½oe±7Ì7^Nèüî\Ë@QG›k¶»å7ÌPK¸MAG\8µT×Êš¹çš¹ok{—SóTò<÷ˆ&°™/.MÄlÿ¬ð}CÁÕâ	O¾”0"ˆ—‘>›ËFf¯o¼ŒØúM³LìÓ¿_¸Â·½!ã«‹=_1k×+—õõ¯'.ùRøŠÊüùb~¡¡°b_c¦ÿìªi·QVà‰Þxé¡¢ååƒèãDÈœÑnëyùßwà§{Û¤™Š†ß¾ˆ¿	òÜgyœË”ˆç,6QÈ´©õË°›ƒW#ïÒa-ë:Ï:¯EÉ¯xk²¹xMÁ‡«Œòi¢„åå&’ÍYH¢·›>î6}\n¢'Yiú¸Öôq½éãSú¸ühåž÷ÑR¢¬ß]{ôdÅû¸ßôñuH¦â>*y²úT+'âq¬b€gœÔŸ¸l½<5HÊPDE>=´°4 „ü¦´[€–#^äYaÞlår¼cFaïq|Db88Œ×vDmÌæ¬~yoÕjk¯FãœlÇê"âS-ëÆZ
lÓj¢ã¾• ð›óFÛÜÁàÈ3ž‘žG$CíK÷(ZuÙ^Žf0râûPàÝX„Å¼~á2§8øD¼
4£	5PÀ‰]kAíÂàô€€=wB¯¡Bý2­"]«ÉgÏ4ŽÚƒ‚ûa‰­f‡Í÷¼ô„‹Æ{2´ îBHñ‘tX3Í@ØàHï6Æ_Ïç)é§SßNûRMm”§Á›6¨vW86Ïº-ö4å›î{¬Ø¿,Ø Zà¹ƒrg×-9pF›ónŽ­›S-éèÞÖÖø¥±wd-Ð;›{VX¹º	Lqf¡q³› dÑ¡VØÒU—I*®åÏæ¤`fLG×¦Nî‚/–9··âø²cëv‘Ê²Í
9)ðÙ»(Pøqaf•
óÂï&>÷—þ‹à]ˆ¼–aù
ñ¿ï=¸Áÿ\Ëßþ÷ý×€ÿ½²}àòøßÞ»Áÿ^Ç_ÿ{ï›ož|ûøÁþ÷wÿà¯üôŸÿûîÃHüïonÎÿëøKàC)¸e¡¿Žœðkæ^
ok.Øò­™Q¿.ö15¶E;Kƒþ¢= "(ìÐ\6íç<ºÚ¨{/2§-¼~ÄYÈ¾Ïá‰±«âfTÍi›ÜÞã ½nxnq@¯ª(–×†¸1ÍnåÝ®‹úâ>
Íd)ÝÑCïs/hñgÕt@pûPïf¬sÔËë:\‚ÉSFç8§·wl›oôÉÉ‚ÔÁ»U5ãU_m†#`=E*(á³‹|ËòR8÷?³‡Ùi5ÕwÐÝœ³C×†í†NÕ¼Ô>{›³!^çîµØ‡—
FwtÖæp7ó_ªQ¬ïsýIo\ƒ©€üv´ep¢eWPøþÖVU‰0p9ÚèÌB<Ôæ.ðÁ|}Ç¢”k¹ãòÃ¼ú‡í½•Z\ayÖÇ~ðb´•ý“œÉ 'WÊïG"Ä&ˆ›½x“Ì±í1 óŽI)
	óR0üÛÜùœó­&]hwãX¤„œ°änhêõÜÀ+`23|½4üžÉBÿ²}1Gßé©¾pÛu¯ÏÜÒÌÔ\Mÿ˜ÿ|¤{`/\m@&aMØž™µï’öã	{„‚Ô	7%É’«—Á’Ú:ànHÓXkÅz‘Pß:Gí;,Ôÿ.xâi‰T#¼—Š*=onñ±	€¼¡åUÅý«ã4‚§©ÝV2ÕÅN<áßcš|d‚¥Ûô&´–qÍu$–Õ<ÏSg£LÙ\ÈŠ8á,C ‘‰è¼FÝ¤YÞ—Ý“BX3¥³$Ëa"¬œ³¨àÝâPGeJòàCìc/&±u³â½ rö€ó©¤MœÎå»Af1µÀðc}”oìdw³ËÈy‘[TH8ÑÏ 5f_¥ÞYWB‘XÉbë7³FÞ³ºKy,»dßL@¦`ñâHÏs€ê5ajz$6f¹nXý‘¡Í™Õ¿´áÜ®ƒE«ãaêÅLòÊ°uëÇQµ(‡ùÑÛ@Ç³’t´ØåÙŠy©;ÓœgÌ¨1#Ñ›‡Ž½·å”Åy|•T3,4sr09‹ÊºÓŽNŸ-!ºR··ž½Öp~v£Šjw_‡Û€ÂšQ`óH(°"—GãS95œœè¨‡á[;zV|Ž/hì]Vwø:®”9­&Ð#™{ÕoôJÍãü÷¤Ù2	Š6â¦î‹¡éR´To][oú{]û|ôM›V§iÍ;—AHwÔý€ ©þ…¨i›°	6ÍïuM¸iˆËlÇÀi,t:›ƒÍÇô±×8Ý½;^QtY£tÎ•6¹´5Ç?ãH;?ËË^~ØKE†dxíu;%>b1õý˜l;k ì©’“Hp	X67®|>:[ÌJx¡Kà²IHf†dû¨¹¯ÑžeÕÏðMÌã—Ef§&Ë‚°CkGÌ÷ŒìµAv ÷N
á%¬¬WÖŽÏMbõ]j[èìä6§•š ÄñT«1Ôö¬Ei²õ/€6´r,*òl˜íëaÛIk@aÏ0¯¿i 6éóW½¦#ëÒàk¾UNG_{ÊÊUÂ¯C©×Ï—þ^w¬¦@/W¾]öZK^
|íóµ\|5\v_zÁrÀlï¾4„æi—[‚»]ÂBSz„² CxtOE\;x7¥äî$m=å&Æõæfø´=ŸgÄO‹‚¯@M¶Üéj‘4¼Æ‡Z™Ù³¹Q8.ýÌJœ,„£ž6MãÃß­g@MG,Ú—@Ms;ø'¢¦e¶éç'ƒ:Ó“0Eûƒ0«B]u˜lBeÐl¾4`½0†)¿v¶›~-l³í£s4	`Í^Âù‚¹¤d{å?8&ÐíÍî3>xaûèÏCçÚÁošTÏ {zWÿèÀÏ‰`•ùh¿ ÖæQ tì	/±Û€°·VïìW”	Î¿ÂtÍæ¸Ïsè;ìŠ¹ùG*ò€×N'Z¶¶å
Ðõ,S`Ö— ƒ'ñÖÓ°Ö?^¨ÄlsAÓÄ:@›“"¹bXk‡ŸNâ©5à{ó"nŒdÚtÚ:P³LøÆKµo_¤i™esô¶P¿<|uöüBðw±v?×«ÏXŽÀØ•ÈC^$Q2«àc¶g'$aŠˆ¯mï[t¹->p›¡œ÷Ý€¿8ðÁå©¡Ø§Ñÿ©jn²»Œ/4²;l=²³—Mó—®¥¯"ó¸OÊ/;´ùµÆ{®>|;û™–ø†/¥xŽ Î©=žä:ökwphõ+úáµ«`Çûr¶—/Œ‚H\>¬uíeÖ¼•þ\¯oüXòª 8ú¼­Y4Úì¼[e­á:´½N ÐM¬iýÀ&æÇ[®÷óöº¢n¯7¨áÄ˜òý~Ó÷UóñÉã•µµe?sÓÇ§M˜ç¦Ïš ÑØî¦?5}|Ñ¥~Õô±½Ò´^» uÊÓÏšž”[ºêÖú¯¼õ¶b–;÷Î‹—TqL÷8{
­>ÄLc\Lgó‰Ò„äU·i•b„œõ‹þ¡~ˆ1¾‘ 7{Ï±Iè´½SHÏBºV¸«DÌ-Æf‚+FTæ7p ¦¸®å±uLÄCá×_—xäb`ê“Æl…¢Rt4—j¨•¢õZ‡>qókn9´Š*´_ë;V£mÔ¹£¨ZàŠ§Sc•\‹ûõgDxoO‹H¿wlãÓÍO©°ÎCÖùâÂø8	_‹ ˆ0Pî²4DÞ÷|ÑÔÐ×:ê·ù½¿SxWŸêmoÁ<WÐo€Ù–dœzüŸ8Ÿ<£ÜP3l>‘h?ù3”ýÈSëBæOSt3qáp¡‹çE½8¨äªQ¿y‹žp¥ÊéûùLì~²Ä£-›:eñPÝR¶UMi§Þ¼f8R€˜ÜÆ±óø~zÞ®CŸúÌ8~MR=÷Á¨·ÊB8d3Œ„•¯
G€-Ýv„öŠ£ÔM²UW©öéµgV¾€+ÁËƒmÃÛƒuè ,¤ËÇg$ÿ²nsaÁK³â
øÑ&ò!pLDtb°ynÉ¢m3:zË’—Öp&·ä¸«®G1ðµaJ7_è¯ÿÿÕâß»w÷ÿw-7øÿ?ôßløÿëÿýàÑþÿ:þøÿoï=yôäþþÿwÿ×„ÿ¿¦øß?øÆÇÿ?¾ûøæü¿Ž¿éøÿhüoFŠÿ}UL S#_1€]ò39f	ò-Bw'ØDš"@|Žñˆ7d7dæoY@°n®1@Œþîhbñ,~Ü2êõ•øKòŸ ëcH”MT"ÓÕñ	`ÔùÌáÎÚ;WÇ$@qâ“d.ã
øäe"€«Œ¾úå‰¦	ü¬ìBJ®ˆ‚ MV|Í<r~_d©A¾6FÑ€¯MK°B;Çå™	X¼é~i=(>™Ô@²-ÿ+3¤WÏLôé]à_…ã@ÀW#:|äWÉv0°7ýîDÝË‹4R¿á:¸á:¸á:˜‘ë@n^ÉÀÔÖNuYÖy8L£>©›ø‚ê5’ Èëª™"=»,/â«r"ˆél F˜MÂšR}5Š„pºÂëêÕÆ¯ÿm%Ì¸m\>.zb‚¯;ª} ¼'ß#¦±(ÀžÂ®ïO‹=—¨åLÙ¿ áBÃÔF—öå¥`†×Ï¿Ð¼¯~†e·.ÿÑûÛãh³Û@Ô0«ü¦Ùäµä*(ä‰ziÞ†`×žNÞÓ´®“ÁAÔCãðÉ4rë\ÁE ™ÐAh3²:„U\	µƒ4”OçwÓ)’‡øñu)¦9f—¤{H=!üëq>ˆž„ÄüP¶êÈ	}E$°ÚtHSÆûÍÁûišwÂ!úz”bS¼£ÁgPJÈÌŸÁ&‘|ÊJ)!rÎÎ+!²]5¹„(üwÊ0!¥?ÍD¨(^×„”¬+$œëDÓÈÌJ=ÁË¸þ‰§Š˜ãP„‰B$û$:
Ù¼?'…èúLÄ"Ç;Å;E–`§ht-‰¢¢ÁÝdFžŠä[îìdò)ü3+bïê”?êoî¨åÑCú¹5$ù.ÄÍj*éEÒë«3_49ÆŠš§Ò_„ãkâÀž9DÑ·MŸ#©ÈÏL‰sÐ„©Õur·&µúŒÄ€¨Àß:Ú¨ÌÒ³;2¯A{Ivàçß/óÆ{äçÑo¤¨>‘ƒc†_‚ˆ#î0gãHwå+RrÄ¯zÿ¢¼Ñ]ìÊÈ9¥_Ž¡#n¹i:’¯##ÆÕßÞ;"/ 7¬777_âïÿEê± Š                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  