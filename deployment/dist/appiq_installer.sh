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
‹ D_†h ì½_oI–/6÷†aúùú9·{gTÔVER”ºÙ­ž¥(JÍiQâ”zfêdU+GU•Õ™U¤8jØ/†ýà;0ŒÅ…†.ìÃ~õGÙO°o~õù'"#‹TOK»·›…m13"2âÄ‰'Nœó;Ý^z–MçÕ/ÞãïÎ;÷·¶úï=þï»ü_þ÷f²¾uçîúÝ­ûðŸäÎú&üûÉ÷Ù)ó[Tó´„®œ§³YÕÉçMå Øp¸¤JbÿûŸËï¿øoþË_üÛ_üâ í'Ï“ß%òÃg¿ø¯àð¿ïàø÷ÿ~½&wNNŽäŸXãÿý×A‘ãžÿ»~1éñÇYwVçÙ4ö³_ü›û‹øw+ÿoñÿýÿë0È›_Óï0}ýe–²ríýÉ+×ÿú`ýo­ßÝøEòú}t&üýÌ×ÿæd2Ï'Ùƒõû[›÷6ïÝ»¯»¾¾qÿîÖ'w·V¶î'O÷îí~¹ÿr¯û:ÏËnl¹>ØùíþÎdôâ«‹ÉÚæwwwåî§É1Tzúûe•Ô_ù—¦ÃÏõÇ«~í½~ãªõë%Øÿ7¶`ýo½×^Éïg¾þeþ»½Iqš³ÎlÒ~äo =îÝ½û.úßÖ½ûë7úßùÝè?ëŸ¬§¾9påú¯é÷ï®ß¿Ñÿ>Ä/ªÿÝ¹»qçÓ­ÍOnô¿ŸüOÖÿ{Üý¯Zÿ÷ÖkúßÖÝ­ûÏùu:•²gÛÉ±@rXƒEž¤Sàre–•U1M·“ãlšeS±AVõË|6Ï‹évòEg%Iö^CÕyÂœ•Ì¤ü„Ë'Õ,ëçé8ÿS>=Kòiòx¼˜Ïáy:$GY
%Ÿ¥óü<KPjäý®ºÐìn™¥ó¬J@¢ÌÊl”M+,uxô¨Jæi>.Êl¡Ÿò]¨ž²ól\Ì&Àém¨5`£ÃïÎÆéÊN:Ô›aÞ‡öËì»E^fX¸j'‹
ú”áHòDV2K±—Sxƒ•U3ÌËj_©ò³)4ŸöstÐ[ Ê,› fžUÛÐø<›à7ù$é˜få 3‡WÝËt2–WC¦Hô]‰êL‰BÑ¦g@«E™Ñø¼2ó´ze;Ñ'’vEV¿ß€¦F¦n|Yå•+e	h>4ze¹Ä §æ§“tÐyuêªšá©Ééœ-`fÆù4“OôGYÿÕ8¯æ5zM:ö]ÁE<_Ìzù´š—ÀgÈ-ÛÉ÷Pkøb”5°m;Ù—ÑÃô!û ó˜"GjèÉ£¢¿àµÕVhÙ0M:_6ñža]ÍƒÈÅð—ÌXó¼Ê`ôÇ‹óüßz7¹}›»ÜyLÜ¥{sû6QÈñ(µUL‡˜kÿX,ÊivY§æS uÊt1•we%$óbÑq‘aÚÏ€¹Ï²
§ÓcóäÅï,û›&Çé”F<È‡Ã¬„Î% ²lšTùŸ2þtKgžšOÃÿmàè…ul7¸„Û>¬›y>¼¬¯ÒD¸Û×,ZëWg,´3”E>0‹Ô1É‘qŽúH.(;ª9Ìª÷jÏ5ÀCÚ¤!ý ŸØVò«ä$ë¦ÈËçn¦*‚¤MÒòU°‘Ø1‘à2)†Cüz2\LiRA’Î/©g¸è’ê*‹iþ'¢j,§4Ðì‰bVÀ6Ð–ÓØeà]àc¦;,Ø	ò¹TtCbÙl…¬™
VÄÁËC ;6÷Ø:3¥Xv q± ÚV‹|žžÂ ÕøÕÒ©M‘’ò‹Ù ?Þ¿ì-gŒ3hæ˜+;ËÍdíœÃb¥¯ÀäÃ@´ì:É··GÙxö-’yT\$i­˜^‡ÄÂ8XYÄ(ˆãok´°¬ÒCŠ“4ý“/b±â?×CXk+¤3·2æ…Ýyeù˜šL'ÓÍLµì5HRÜ¡ÉE>™Ú}ou® º°òqƒ4MvP™\YÙ¿5I.…n¸ùåðßÁ¦¾\#‹\Om )M"çR·(›¤¥ÛÚNì@¹²€mèÄòPoYÐóÁ%ìô;¢ Í yùÁ[óºsl8Á—{++·o¿@±½ç”C‘¶Û°Â:É	JiÑ5”8‘ž°ÐîœÒ’š¦çù/l#µù;¦²ò3ÜHþ°(û£|žõ±(pÌD“1È«þ¸ ""á«	l{"ì+ìÝh19í±çØ_ ÅÇDV¤cŸÉŠ’úOœÞ‡Áœ1x¤(´¿\ÀŠ£W´'éòJbw¬`?€Ù)ƒXÔ°5Á¡”ÞÁSì{îºæ/Bø°Ý<!Ú¯ÍªÞ4'óX¹R^<‡«= '+› ¦¬ï;ðî¡ÈpüâbBš·Þ–`4Ùü¢(_%ÙFŒuŽáyt±z™×Hþ]¤¸£óò–ßÁ
Ë}\]Òß¦~æöíè`°›‹2ô«äùô´HË¬yÚ=@â¸`’qqò@‘^>Ì‹I6/aÞR¯!z©™´°Í‚~Y\°ÈÛé÷‹L&KÙèÎ[ÌW¨ÏKü
Ï-Šµ(¤·'éim™ñ0æiÿU”»xËÏf	Püv°ZÌfE9çj®<.°ÎŠsœX#Ë¹{p_?°»²tÄÌ`Ã®ßIž¨ £ÖXˆ(Ý=+<¢8”Ù¾8Z‘M‘ŠJÈYŽÚJy¾íÒ²rÍ›xXÊö™é¼Ìqƒ-ç}ÜñÃ¹ÞA+ˆ¾ËÚ›/³t<}•Ï×¾v€ÿ6Ô=†õßÙŸj9ÁLÈ¢"ìÏ“¢8kø¢.À¾…7__Ã|¡¹?‘N‘0v²t½‹|p–Í©vçØ™Y5¡eç9%¥{»é¤	±ÆlT@?Æùi™{¤}PÕù{OYË²À`#Áæøíá¢%Ób®Ö´Lï7L¬<rÆÔ¼ò*óE)Ìu§° òs”fÒaØ†Çeè_
ëùŒž¿ÑT¬¥‹A^à÷Ææùc¤E5JéDÞOg)4Eé¼Èó^÷÷\O5Ø‘ó)Š¢‰.8KÑÆú>¡š„ÓÊ·ß~»"3Aï‘Ùë¹me{åŸþüÿéÏÿþ/‘ÙyArØlËðþïAu¥@-ž¤V\Wýl
.àÈˆúãµ‡P³ T^­Õ>F†ûùB6<öÍÁÉ”þ³”¦±\°ØÁ"=}ùîš&Õ«ˆÒÐ8†çÓ¬ƒÍ›³,¶õ…5Dí€7£# ²]ØÛâÕœfö2Ü#]1«ìé¡'ÞçP9 óíi61›w(uÍ"\ZØ|y·,ªªcT>îa5§=sšeƒŠ¸…Ø	¯ñ“èèŒ£yË>ööUÍ^M*BÖ¸±ŽSØ­G¤,l'ŸoÀÂ„Þêeù ÆBÓ(U6ïÜ™Ô‹kU
­ß¹sð0Á=÷—Ú„å#ù×Ÿo'0rÐ¡‚ÝO¨%5È]”•sÃK‡‰s[ -»I‹ìfódŽ¦„‰”÷U}!Y©}¸ŸŒQUwmà£õ¿©×‘®ŒVÞ‡CÿŒ‹Ô7
„:“b,-)BS…ZwqU¬‹0(©¶lÜðC‘©‹Z°,bFJ¬OŠEDÃ´¿ÙuÓèFˆòÎ&§°Æ³n_Ó^˜_Â²šÄö¹()Ù2ë'Þä/ÞÛ|R“:6‚’´‘UóË1$í^c ¤3RòíÞŒµmž)íŠŒS§>§¤Fa±ZßŒŽEç}×Ñ
çdé‘>EÚp»&·êrLh}Ä]Jí]{„‰h¯GL·Ø5¤T„¨ršÀ|œy'!70-¸¼cPm|õ#ˆ>!šsF „S`†nßÃó³…RV|õš5ÕK‹­NSCïb*<*tº'³9	‡g Ø¼2Ðl‘vÇ‹	*¬}‚è~™WÄðÛÉî5Heˆ˜-ÊYQ1Ÿ§ãÝ˜À“\N{·oŸ¤%®ÔU*lâ fô•Û¶TÁ•h˜ÇÚ„AÐ£>§š ïu¸/æ­,ÅC>qp¿ÌéTÍßæD¥**CH2°‚§í|B˜GÆÄîÉA!VîùoQ
n'<ü…çÆ‚Ô!P¸X§oó <NûÙiQ€ÒEuö&ÐµYZU õ3å’gÒ‚=þ,+Ñ¼0o'dšØ$íšƒf™É	n{?*ØnW@o ³1ä±NñçŽ¬H·95ÈŽQX™¢bin5k> çh@cÚ+MÌgt:Dg,)eO”cÄ
HùàˆÉX¸ñùRN‘ji¡à‹A(¯jVywT’Õ6­T^èÓˆìš=S™­èãäY1í\Á*Z&àÅcÍ@¾±ÌØÂ@?€‚PÖ¥õq¸hX¦X‚Äµÿ!Ïn3±h…°Á1ˆ‡2¦"LûååÌ+¯ÿÐ½ÊÔù0/úÅ¸Òód§HJñ;8˜œ§ýKu"†%òèð¨ìîî¬Òäû*z@8Ñ%KrâS¯Ñä„­ò³JdàŒjÎSìÎË¸CãÉª‚ú–<¨xQÕbìïÜ¬×±‰G­±NRœóc²Ó5^ú°ÅQ®†`×9[ 	ý£0ª]A% èÇê–GZÍsà.˜MTZå®yJÓoÔÓzW%bœ^^ÝåÐàéo§†UÙâqu¯õ§Q(à¯çV$ù…½ËEÒ#ãÌæÄT»f¿àiÛ›Á'›7Kl‹lG¥»:ÈÀÇ.·¤J’~ßmí°+öÓ©ìt©ÁÃ¼vq¶'µ`â#§Œ†:f¯©Ÿ¡w¾Òê ±‡O¾md@U½ÛjtZÒ¯lÊ—inÏâ®^¯on28Ÿ
zPÓñÏ}xçd7Õ|˜œÚ.a¿Õ‡"“Ù/ý-§©Wr¿bo˜“Bj-´Ëjá|–Ù~g¯(¬´>r¯Ç7àYO)Øþ¢Ž,P{2—¸ýh|ÀÆ¸Úzø´Øm'G :‚28€eƒÅëv’ÍûÝÕ@=Ævä9vÓÃ×TNf¶ïàµíŸ¬=)ÓÙè·OƒC µœ!íXÝßtj·äñCÌo|¸Ý©@Ñ¬Û<H×Ñs,š~ëÅ4‹mköäÒÖrš¯çö6öŒì¢Æ´B sßÓ•q¤6ÅnâM#vÓV-fÓl.g"ÝÐùb<ýL¶Rà<XÕÄÝ4	Þ>«ZÛu›³¾œMÞ´f¶Bw-ãqzZHHúùjx’9Xßf|	íÃá
¹˜xö+X¾/ËŸ¯÷éžåv#ç(3·ë¢®$×4%Ž€âf(æé|!¯ÛDÑLË¸?·´²Á>
Ù€¤Qhb@—’i¿€•E›ºê„ÀÆhçd(-È:øãTš¹œ~ª„ï}hÊÍøioÎ^[mèˆ‡ã­[Ík:°\ÆÛ;x¿må®äöçtâ?Ïäsl·Ë7Íî>Z#¡"¶·+—_–Ó²À’‘äb—*Ñ2mçyvõ@ÔdS|¾ð–ÑÈ¿ƒb€óh)N…Ÿ]Nò©Œ`¯ááhŒ-¼	‚¤Sé[ë¼9›f[ºž¤Î¬á<›XøàjDµCÐêE_gçeb¢jcÜ.ÈçHÈ.G`ªg=gà8låÏÑmy3º±ÄºvR¥ve¬j‰x¼8ä|iÀGnœ Ü éœ?ÓýÎÚEç¬ú|zVÐ7¥_¨eÒ‘•L ).DòÑµ•ö9¼µƒEûHuTMû¸‰>4Fö8œ¾’a~•]zî
¬T5ÉìÄZ8àPvôál1‚QâÙÁ|÷á¢ÂEéY5`Vñ˜¶°é™±ÈÍ¥_LÓµ‡ZüšÒ‚Ü3iÙS/ù·ßŠLtB·ãGè»°(»¨ŽR8”¸‰‘[âY:ÃcÂž®NÍXjû¨“4¾–ßMžfpÚÊ’WÓâ‚}[¬Llprá-rÿÖxÌ‡êú6éàŒŽó‚©ùºørâ¯þ¥ý—o~Ù/Œÿ³²ôGx÷ø¿û›7þÿäwÿ÷³þ5Åÿý˜ràãÿ6îÜßZ¿‰ÿû¿xüß½O?¹·¹yƒÿðÓÿùñïc÷¿2þoýþÝpÿ¿³¾u³ÿˆ_-þÏ™Ž"ÿvTT“+|UüŸå¬ùG.à•³ŸTpBî³Ù¯æ{am%íÐB ‡(åæ¬2eñÇ¬?½Ò‰Ôz‡˜>Ï*ÑÜ·´å×XòÊP>g/3sïˆpG¸HŒŸ	Á8ˆàõûð³£ýq~–11ÂO"mšç˜OÂÖ¶†ˆ¾Ê…ñ½Ê.Í­qnz&¢OôY'¤c3ÖÙÔÅPí¡÷r³Yç•¿,,ËÆß\LŸÇ¶âÀÃGß¨y‰6[í(CÕÌ˜<pX+åˆ.hÉÉ†²tœ­¸8¾šë”³P™Ö»@mÞ„wk»‹S4ê»'ÙüwíÊ‹µ¹Ômh2l;BÑ-IrRãWØØß-èÖœZ±>½‡û¦¡ƒtÞ)‹-ÝZEcÅÅõyfP¾nÕa|týÚg©?S–#÷°ãUæ^”Ypœ^ÂÃ‹,Spô’¶ž[Cü/µWñ+©·gâ¹ÐVg23	ýEIA›ýb!_ù@RØbæRÞh–ºÂ_L½nRHß$7&|˜€l:BU}$Ô0¼ ø.rX›ö‹Èva,¤RSYîÒÀ3Žû|F@êà=OWR;”¼ßzË°¶¡QZÚx–5›bï” ü!¯ÇGgÍ“ô•¹„ÍJZ¦§Åb~­MzÙÖÌuùÄLûÊ×£lJ=ÁÛ\Å ©ÐƒÎ˜S›†G1ß"&·%ºIŠæUò\ä¶¾Í7@. ä®Y"üJøßÃç/Rô~K_ç“Å„’V‹}€Ú¼Ñ_ÍºÆâ-ò§JFùÙ¨£íß/p¿#ñðdYx÷sêþ#_ÂªÆWÜGN6²;ŒÿÂ‹VØ&ÁžªâùŠžÒŠß) XÓ9o©ãQ²´dEq"ÙëyùbCêN»`Ø¤9»{¥rAú´ ]:<!Ÿ7¹‡ðˆÍMÜªÈÛÜØê3óUs£::¯¿ÁrL:«¨ªyåät…[ZS¥;µcE-òëìçÒë0FÐe])úL.}¥µl 9åå 3Â_jòÑÝÆ3äuØÑäza®Š²ž†aƒÏawí€rÔIóRîù¢DØWÐöËA†áBô£ÎÄå‚1~-WLïú<5O®Lˆ]Ø|N÷/%9<Î]g"qÿÚ9ž$D£öá/ìZ±G"¯’“2Ë0Jõ‹=\'³ø`í):Û’›†i¢+È¡è»VsØ&¯·â—cXmÛ	ÕZñ‚<A\dƒ¼OAímºoâÓVŽ¾HÿÝÿää>Á*Ýˆ‰ºKÊ…VCØ;…»} “VNòƒ$ÐU}æbº×òÄïöÉå,ëTé½g±*uš¿í²Qá®Óá£t–ôEì²þ>-.:¦Ïr½Cÿº ÇÇt7†Î¾Õ\7í.ê™Â°/_èÎ=EqËyÛ»’žÐ?&¦ 0 æL§ ½ú]|çÆ’´S”A‚¤¤T sT¤“FæŽÂæƒîÈ5šÖ¤]Ùé¦ÙŒOú®˜Ý"W~W&Ç™éÀÊÃ`Ø&gõü’ãƒeâ<£w‘Š'_%¿]då¥žµev¨Äò>Ã¨ŠNÚ]7‘K%"1Ðü´“§È^1Y¬ãrÄà.³†ƒ¡‘ªËÂ<7Blî-²ß©‡‹|<ïäÎ7¬<+myà9´žÞÛÂöÐë·:qß”8	}àTá%ßèP…>8iÚ°ºaçYSŽ‹ý¢ÌÖ’È¤6n†„<€îÂrªù$Ò95Eë¤®‹z’}S«CþjkÁçö|'¶°¢$¼Ï<DUÏPÀéŽ¼[êUçù¸
?÷b.~D²[ÕÃ!§—µæU3ÁZ~\‹û–ñ1	hêbó9R§þ5©Ø›‚°Y“·‰7´ãøoþ¾öžqaøë(p&ÅQnÆ*<€K,iýÂ5½>f‡w~©gF€>UÎ>Çkò}yrY‹#Š°À£ò²!âwž;êwójIíå´ÀJK†2¡ú¾ãÑÕMÅ°„¼ O€S˜'ŸÝ”ŽQ‰jjeüe"&˜.¬h:)ï×\ÅÇ
™Œt;×„©„SÖ€nÛ°Ï5ˆ¡ªìûbH<Eý…ó±‹‚{±¯
©šnR[o2æhç‹,î¦¸5õ9QšCq‚Âš8¯QSd÷‡\jU¬rœ³Çÿ®_W|xõÚ#J‚¯šiJ_˜c]ç*¦j™/Á)ýUHT¨#çYža*³â÷®¶™í¿Æ¸ªÞØ§èÇ¢sðó¤•\egü¸îÞ>Ì4ñ±ÝBíÕË9èÌ‘‘¡*-GGƒµtiÚGþl¹º¾7Ö6G»¥Gqže‰Qh½ET÷öˆÎÊåÎcÄ¡ÓbÚQê¼ÒíznÁÖÄ±f‡\Ïœ½âCËùúé=¢—Ív‚7ò]‹Ï¶>¶
í)‰û
 ÕÝ·¶	öcD4ˆ)…wK ;ÌÖÏ²Æêezþ¶ëÚ]ÀXÎ5hó=—"‹7\Ìûò
»ß6š¾—¾É–í{v[Õ·Ã?Š-Ï#¤ÎhïËï$N µqÖ*q¶³Ìp±°)s°5ØíXÇäù»Ñl¯XÖù`B³Œš¢íáÀPi8í¦ùš17	 ›Òj$¦ÝS–rŸoí²;†sB ø&SÕ‹JQNiŸj}Ë;Ç2~_&ñ1Urj°x¯_Xƒ¾’íXÀYüv#¾0óHjìH®wPa°¨ù³Ö:J‡3ìæ ¯Ø	ð|!ÞËÝC¤Î!y÷}`1ÿ £­xµ4t{(R}+©!È*t6ž1²ÛF¢%Ž~¯`Çx©Óâ £ðÌtê¼¨8¼>]
’Ln~&‹ñ<ïØØD¼;,aËÄŽÓ½(öF†ú!›uà7ù‚/Jµ{"yõ8ÜØe4.tŠ¶Ñua3Ö&˜ ^Tß-JK£~#ËŠå9â1/”ÆÒâ”Œ/&H¦m$Þìš?M™å›~àß­±cù€lÉ°Ò/`‘âŒr&ö`¶ñ©JFM¤ ³Ó«£•§„ÁÐd1væßc'„é^@wTæ½Â ˜(‘'ÁåÖÝä·¹Ãõädìòíd^°såE:Q„“0)žÒ0ÞXø“¶l,–™Í¬¯VŠèP®áK…ô,Åk|çY(,¯1xÈXÁ¶Ó¼Õì
	õ2£° ðrT3]€8t·Kàf9ÝOI\ß‡qÒ+[]36>tìvE;å_ Ãÿ«oÖ‡5_˜…„øRÍU–òÐŸ…!W¥¿18_ ß÷_Sô
ýÐÿû»ô_Gþ—­{7þ_äwãÿý³þ5ùÿ˜rà‡ä¹s÷ÆÿûCüâùÿ6ïlÜ¿·yÿÆÿû'ÿóý¿ßÇîÕú¿{wóî½zþ—ÿïò«ùÿvp8@eÍ¹_ê ¶ÆUnàÐz&e¸#¸=v†Y`ê§\qÃc:²J™¶w>0¡qÿPiKÓñ æR7QyÞÁ_?…‡ÞiS2*€AÍîßR’‡Ú‘Î×’º¨‘7–ñÈÐXÊœžüïÏ-\WòÃ½Rß¥?Ðk\ñ~Ûåðyìª)×6`ƒì3÷U.­€D&XÁÎ©Üðòò1‚[ZÇK1.¹ø†ÅSÛ	Ó¯ 9Š©"çi‰‰›s¼8„ð*üð9ŽkQ%ÒÕ ÓPÏkè¥Øc.ðìFˆ²tÑAçX¬N’™m'–YÆ¡…Ù0ó¹]Ä†Ò-ÝÕŽÂ†­:÷i†ðª7ÁÑjÛâ‘––à{õR¼ŽS9ôaVâÙhj€„ùQÖ¹ö¨|,Ù€‰1e"ùÎy&Õz~ò……Ûc¸?¾‚ˆæ˜—@Ó%-—C÷Çvr’Ž_!t®%=ƒbÏU“ë½Ý-Æh4¸v±)ù*»$ GÃäâšnî†…b¹f@.îîv³PëQä	ÂL&®¨¶¬ÊX¥™¬¢NÈÐÆ¹>Ø0ÈW}1õÖ§#U¶Þõµ}ä[¾š¢Ì.i€nüï{ÛÖÞ6ƒ´F<ûä9É+±Þä&ïIþZzškl i"šI–Íy/BÉ†“f¾c1 #Û‰§–T^špK0¬Þ~qÎËü5:­¡Dô_5¿¬†-ÏGÅ4#¯ÐqÄ›ß®o¬­o®­ß][ßBo ÔÉZfHÆÅ¢Ž®'•÷ °Ê4S¿¡—‚‡e|-®D^žeºy×p:hî1¼ÛÉKÕAòÖÇú—R¦8ó¥°ÜŸ½ÏåÓœ’ Ðýš+jí_ÊÞHbÅ}ç)ƒž+@ô À!¢þàþê¡¢Z_2í¬¯Jqó)ºP[LÌEB6°ÍŠó¢Ù«Þ•D£‹hŠž¦°u·{ç#X¼[ðŸ:EÅ}¹µÅ…îE±[vë—¹ï•1CÜ{oJb‘¿ÑóïíŠ9ûoøßøÒh­Çãô¬å3³Ú"Î’ [‡Ål¼ ;$Ýì•LŸŠÓz¸ ¬sUÐâÊ,,ç
Sª3¤CVëj™òëëmX–ð¿Í«ÙÃ‚è;'¬Úû‰Á¤»}ÛˆAÃ(‡—e:ÉÂ?äÌµ¶FP~¶HÇyº±£ò9ö/UZ«Éè dµn‰Ç˜r¬Ãª[íDÊ%É˜â&kå¬wÞåg®ØAÑµ3ËÙA	‡þ“ËÑÿ«²ù‹YË~"	J&‚–Z«ŸIA÷Y(Tëb[©­¶´+­¼]U]ÁIoÝªFÅbŒ*7´7å«¹…"W/\g9¦Ñ£u¸3yRÊ`F 3°SÛÊƒ!¬q¾‘l@>™’?H—IX¶`“[ëÐz‘Â?‘ö·V¿1cÅ ‘|Œ£Ž¶VW»ˆ[º3­.²²Õê™NAýaK=Õ×þÜë'hŒ‹ñz˜^¤ù\‘Ù}+ÒH›i‡?Øâ†Ú±ï7Ó±². 
‚ÞRÔ‹G{B:½Í¯M±ü`K”ë=ó]x¥Tò«èPùC1RµyDÕN+¯v>?ó|Ç#	þÿ·+¸ˆ%¡ƒ[Æ Ì»Ëî+V±ªì­`$5¿«,Åy5ÃóÔ¸H¬‘P¡ÂH4¤½<ÆVèJ½¼&»#ÕÙÿ•—°ôŒ9
¦‰ÞvÉ¡‡gçˆ–aK*?å¾4MŽüÁ|ËíÎà8Å#nÉëÄb;Ã)Í=L({Ðvòp\ôMdÈçºÓ_è²‰@l£âA.‹þÚ~ÙQ>X<éÎª.£þ°ÿ¼æ2rº§—èHÒÚÍË>îJ&iÛ¾™KàC,W=ŸÊç›bw8Aˆ‘Þ™°p úöÐóû2*û­”|¿l•Z¦‡7Ürö ÌËR†rbLG0:Y¶7tæEþ#¹Äzc‘ZCÍr­oðWY36s+O'»üõÏš¦´;Ì1ÎbÛŸøŸg°Kà‘VæéÌ,Ö¯²Ëþïî‚VWLo­®þÀÏS°òyS¦ã*ÖJ†…0Q@­&ìèól<€>´“[Xão³×)ÒïoÅûÕÜ¢Á×šgë›·"c ´Õù»Q¯¢:1ùÄ"«-L­W9áFå­íìqAè•Ë"nU÷=K‡µ8€ìš‰ÆO.ñt#TÓûÉ§ë7ð‡\fV;MˆÈ\c´Ò]Ù/÷™¼=j—â¶“?BÛ]ÁÙàsûø‹ÏØ*wšÁ10ÛKû£–ûFâ7œÅÜ~j&¨²€ivô¨åµcIK_Î.9ÌÐŸ›ƒ§¬Æ>¾„q³Ð=v-òz§îš=ëM²tŸJÞÊFåuõÀ.>9Bþy6x‰¹‡ZoøÇµïmÃj»ány*²A]'Å=Ev¾b­^-óY©(¥jÇ
_¦çÙCàì]Ð¾³Á×ÀS­[k&TîV#å)0#½|V«ëÐ¼‰r¤ÓSyâ[·¼ìk·Vëôuu¦ŒµFÂÕnIß©`Ì|"Û·ëþ‡‹Í¥ óV\tÉ>eÐ€úJ´xk	)Á²V+g'÷~Q–zF{å5»¢Ki¬bö7f´?|c¶}io;™—‹Ì<,@!¢Ä´²ª‡S£?¼UTå¼I€h/qhûƒä-|Š»Úú<Sò¦ÛíÚ>½MÖ¾ðNµƒ!õ«cO·ð|V<ÌNÊÅ|tÙª³š¡­o¼‹¼uÌb–q××´	ö\‡ÝöKmÔKmØRß4Óéõ\SIÚ¬‡ñàéä[3QÞa?ÏÞº9zðÆÎÒ”ÔÌïS77¨M—UØ¸rx¡W¬>¡XÉê³ð|ºÅ©ôÇqŸ][òêYúË)ouãp
ì‹p.ì‹Â„+ª¡½U¥"SgÔúsØ9ÏQA›f²&¼Õ·D·Úî|S“g˜ÖÃ“d²yñZ‰¬ ÉøcQ«íó–¿3·ê’ž…/[b»|1ŠÇ#ŸŸ”ÎpEe†3B¢–%m„3e'Š¢{QM‰×êŸlìÓ:½ìæƒšöN:j°ÅUóhk¬†çÓÙbNnÇ³Þ¤ŽG[±ªw¤¡ˆ
núYS¿£‡
wlÄ&^Àj\õF™gƒ¶}=šåft<«éÅÿ™¸ËÈ|p‡×ð^	@YÁð5Ä_Pï0C£"QÏÚvú>æ)_î#0GíÖb·8bh;ù<ÙlÌ üuŠ¦Üº”«'Ä-æ®Ô–$Ò
¿dÀþJza®xð°žQ;K_Ù”Äè#¨ÊüÙÿÂŠVÛÉ˜×
£1²ÉÌG:ñá‹†žì£6H*õå—µÏÜc—›ûóË:1ŒË/¶uç—êjÇxRìÓm 1]4·¯ŒZàI‚r;=hÊ<çª,Ìne>5ÀèXÊSÈƒ[ÉSš¿“úÙÕ‚ËsÅ©Ød%	‹6›FR•¡Qy4›GØèVÍ‹ÙÇ>@¯þwkµÛ¥¶jGê&ÙÁ%	ýrJ·=èâ¿j¯ZoKeãtVeƒÄR“õ×®ªÐXZ›wîÜñíî1(é” 
Âc{z¡6„ªÍSô;Ë0[Õ<k­ÃW¡"h¸ÙkÚyná~ü5=¨™Dþ2;ãq?"¦oU<-ˆ‡½z™gÝÓE>Vš‘ùaïw1GÛ6¤;Î¦góQ;Rì!·àì”˜/Ì¿s’ÃdÌù]biS¢Oüj}³~#xðCŒšœpW&RÏbŒÐ˜CõÌ3©j­¶1Åj3 “Ø9pFÿ2›S5)
9²\Öš’øt€§¦UWãd”WÉ)5§™É#<€®‚rŠ}jÈÑ8
5˜ŸD²³KÄ/*ã“¼6BkG‚ÃQ\‘o¤Ù]L;.³±\ÄàK+ùMþ0Ö`iŸÐ	‚¼œ®ƒEÉÎZ*ù“‰â§cC½â©ÉŽ´@mŸÜ|Hoç@{)ô7<PlMÜ?‚CÁ¡³\P@«ÛW*ç}·‚#eA*Šv_1ei|Š§*­¼£†l45bÄü…&SÞ)UÆ1åOaIèVÐWt˜„^Óæ¹~iýÌ¨RÉ×Ò!îH^h1¹Û”yÅQ©IÔ‹Ù, #¬§À÷¨h²9VùvGëqh'c×¸"¯ø¼TÎ„Zss-8Ð˜º#Œ$C·GbŒ±’kê‡ïú^vãô4æü«YÕa¿ü(×@[F·¸IBÍaÛ‚,'¹|µøèÆh:š<£^„=ðrƒäú%žs`'¬+cOÓK™Mé,H k»‡Òžâž¡Du„ä¦òÐçÚ—LvbòÉ¤ðÛ3Æo©+ÕLs]¡N6nOò+K›· È˜%ÞWäe¤$6óCDËr€×'±âFMBñÀlÛ¿*æ0[È÷Æ½ö³½m`	×›YUQ&ÿ­Ì$›€åžÂÔàI‘ñ
þVý|\ 2º7ñ1»žÍ771ð59j¼‰ƒg7¬º@É¶wÅ)9vºÓ>Ë´_Ä½Üü„Ýu^Í+‚è°îé˜¨pG¨êËÓð!Á5&„YVµcŒÔ4É¿}V¾“~Ü$ØÃüÐÊ3m;Ó§áS¯·Äq%ƒ%7yÇ²ÁaNÛU½WJê*šÿ5ÿÄaUPiZ<–òÕ•—½Nà¡%«\U¥çÒg·¾¿¥5àbz’Î@I¯žóg‹ñ¸Y!n>äx;ú¶yë{wBRÿØOµNN9GšñÁÙÈlg<v·3uï9õîk@Q¡{1ÊÊ¬Šó £sþ£KTûu—h³ÔeòàÝy¬êª“t­èšxh:sê¶íÍB’ÜÚCsžš¯[‡b}Òº‡á¬Þz\”gÅ<±…åÍ7ÍÉI˜<YÔ{vT_&;¥´Â™¦k¯­NËðtÇOçPK°·6¦UN*,ÝÂdÓ~y93á¤$H&èÎ‡$’ÖLD¦úð·ÓïtÜ>¥§ÔSòê_L1ä,äÉ\ÙÕ³IsSÇÇO×Nž‡°HaÜ	|cÂèHF»	ÂW:èÛÄUT¢‰M;ù”€Á'Ô›€:Ž;0ˆ*´î“àÜ—H¿E©·ÐT.=ý²/‚éˆþA~:ã³t@°?Ÿ¯#ÃVç²±ÿ¨˜{}®gëvÚˆ± >ÿzçøÐÆJ3P8ÕÑB+&ëÛ¸°Be)7#Ú×&,k{hE .|¢«»Æ›žšMðôà–ná¦l¿`ƒÉ4Zêõ‚³kóBbþŽ%‚+¡¥©%Rë+ÃöÎ,èpe#ojý<É÷è‡Ha¤û¸©ú¸ë	Õ>]uÝG-µÂÎ‘»®þž‡íÝ]Õ;ÿn©öÝàêi’!¬Z^MjÓè¦ó6+P¸%ýu«+ÄKsÝ¶æð-êöÂB?íât°Èf£Ë@ÿÚ³sºÝª™£IçJåÉ>/BÐ}þÓËO’ébr
ËEL‹6¾D¶?QB¹m¦_S& ÷^@šT±]»,ì–qœ3øÆ¶4ìù©€¯I¤+ß,`¬ü¢,×$J±´l9^«ð'Ôš¤—_¦åÖ˜â{<ÎÎ1M+8n-º6ÂÈMk…°Ø…ñÉw†4‘’”ƒ¡Îys­ÎáRÂô³§!2#¢Mò©jäùbÞ)†Úõ8Í³œÁòãÁ†nÄhº?ÅœaÉlQÂr¨â;ëñâÔžåj;+¦šCòK½Oj«DÕÁ\­J;
—K
®§æ@˜ó–‚s—qU$ˆ×Ÿå'sF;, 3—ŠãÔ¨˜!8­vÚ‡å
¼Ã/db²…mÐ§tŒ  xã-hÎ¹Æ²¾ÐèÐ°#÷! 13Ô‰Å®ŒMÓ	‡À?úÊ†…ý¸w·ƒÍi‹Îqåé‚|ª´Nº˜•&O=[OÿG:Ç³ÌIF
Ôž.B‘L@¤£¶ÍGÑ…1Ì ºMš›A‡¸&„c´IAO|euŒÈ‡ÃS·¸¤`ÚOŠtlïpíS¦¿w{k%«íä“­_þCHö¥†*ÈG›5ß×+ÝJl]«RóSÞfc[ßdƒAÏXEã€a*€ œ¤dGKº@G*©8B¨÷)vK"ÿ'C«S».”~uPädn†äŠU=k·ÐJ¢©Âz¡…põ¬Á¡Ž~¢øAfœÃª‘ÂüÎ‰ŒG)b?R¡#òz$C8èÐóXá›ÌV¯¤1/ãhð.Ý0¤Ó…\§àv§$LW¦õJÀ9Ì£z#ŠÆ¼äÜJ+‘|-ç¶òSÿ¥ž¨tqÃ»í¨ozÆøoµrñ§ÇîGtz•AOŠµiÑ9+lº1bZ¼dDÊ›‰yBà*@pKã1žÁXY©Ô¬)<Ü¬‹á^+°ë­½ý„%5ñN-Y) ‡Å ­¹ÓìÎ;x†ð¡5ª˜­~@Ð§ÁÆ, O£C©•Nä€PE¿E!ðh (S»mÄQê1ï’C/Ã˜õtîEµK[±±!ÌýÂÛ“°¦!¡/ã×o’qþ
¹GÅæïbzæÏùâZ”ÓìÝñ?ïoÜÝ¸Áÿú ¿üÏŸõ¯	ÿóÇ”ïŒÿ¹qçþý;7øŸâÅÿ¼óéÆúÖÆ§7øŸ?ýŸÿù>vÿ«ÖÿæÖÖÆýpÿ¿s³ÿ˜_ÿó‘a&ôÏ•Ú¾
øÓ¡ç“…ne3Ú°@Ka>àŸÐEÌ®>–Ô‘Œì6;G»æ¹’&¢¶@°QvUÕ›|€‡bµ¤FA^€ë@â¥Øe3¼'G£vEÿ mþ@MËˆ éŽ•±¹â¬š	NÑ×´1q7|ëšÓÛ ×êÏ¯ÃÚÔ“krEá6ë)çO‡KXËBY‘’*›¥ÆŽÓ×–Ü„m/‘Ÿ)|Q5äNÒYŠ° dkQ˜CR‚\óÈÄ™:Ä&–Á4]yøKæsLen¨–ák"\ÌxœYÃ7uˆgqÛôÌ¦ÖÑÄ>‹¤Ô‘úzæ·5›óÑ(’Ñ$;àåE-ûRªÔôÐÞíî¯½øof^PM±1uç¥ŸeØük4IE€‰«¤…¦¨¶d:t¶§¶6/­6òOæe1¥ù”h×T1q œ=;”FÊ}9à&ÆÂdVÚŒøØÛË~ÔœüHJ›Ä2 ;Ým&'G°û¤IgµÄ†¹P"¿†x®¤ÃHj”ÁêÊ»€sjžõ :k,ˆUm·¾õæ‘ìä$áÑ4&R%åŒdzý­JQV	‚™ÊÆ'²mZ>¶TÒEhéH0|/ÊÞ«œDnnŒ‹Óñ™.9õ}ÿAv»›äž%6­ðoÂÙT»ƒEÙä$H×Ùÿ#;FlÑØnÌ;Õçî+Œ˜i?¿ãåŸ‹åóœÆðß4×ÒÿüÿéÿAËþÑï;‡°xþ”Ï(Êt|!u^ƒ…Ó¹¨ôþgZ“ôù#çâLul±ÍjI†ë~>*€[±ÚŸÿS,±Ô1îääëHÞvÃ¤r!~ M?	MüÓ?üoa–)”ŸÙô¦ýšjD6Eãoÿ§ÿ3Ìåúj7!î,™ì‰‚KvÚ *-²3?¥÷Øî`×ÏO½ï%¦N~•Tìù²˜¤ê wr¼r»ám¿æ·d&ŽU·wëäñÈu*áh`¿‰ûò}ÎT¦KOïZâÉ:¥Wn«|Á’<iíù9äW·Ý”PÆìDHIŽ4Xø—‰r§oÁýÃ€zy¿Î§A	ôîd—Ë« áÿ<Ð­7FæƒššW]Wøíj²ÛCV¶ô·º”¢5‹“(6Gé1?GÏà/(f‡19<¿S9LxÊ®oÏMÄÎçX‡°-’–Š]‚Ïg
O9`y›Gª€Þ&{£×@ãR®¾ùØ3†(0Ã¸ op®ú¤Ö ÁÚ™²¤‹Ð;`7¾Q¿¼ÚTØ¾æ&ØIÔ¸ˆÞ>A_Î`å[Ö:àcWÈV[JIŸÁžèO@©Ù˜Çz¾ÁYú[¼Ì-sÚôdN}&£€Ã`bh3Î!<Œk3	¯À‚±ƒo,dàg^	f'*AÀ2]PfJ-iØeØÅ¼Ö0\Ám5ä£€îO²ùïÍÒ#ÿší¬yA³³âXQšz­¿Órå‚½¼bÀø	È¢[œVŸ¹÷ÆÛ8zí-¦UU‚uäÉ­[¦*žê‹bŒˆ‰jÿõµ.æk%)Ûê¯©<ïþ°+;
¶%ä{_È—]™kòÃ¨aÜÖÃ%ìnœºõh„¡úµAQÕp|+Šï6ì×dÑÊÜmðÝ¬;/˜ ¦Á·ÜƒñÒ‘ÐtJyÍËrúÊ”:÷EiÌ9ÄÐÎ"G(ÕÇ““ÝP“u…qŠÞ+‹ã? ‹VÙ‡1Âª­NœxB&cRüz›´Bd	~t›‰Ñ}¼[C¡þ|¤l™>µýn´Ý·ÁÛ+o-‚ˆG”@yûÙ;©œCýFóêjmÀŸ—cL¼®Ò D€ñ[ƒºFÑhUGJÑŽ%Xv+æ<JÊI	)ì¾µL%å-,FO°ãCÔcûYY™V«lþÔ4Õ"ñÜ–($…Î"‚»ë&€‹tgé%>Öo›QW¯lN$^¬­úõ³Úã_ù%#9Ø§Þ¶-LmY i-¦¯Và¤†'ožc¬-´à$žfªp‚åqw3“¼æé'‡Ók'oÆAC¸ Ú“·j4ZžZh:Npk$£aµ8FÝîM=š‚P:"­œ„´5¼~q©®Q{´ì31·ÿnAÞ/n	=Åä3þÿ†5TXìÈÚ(§ì*°ÂÇ®‚Š÷±ïi9˜²Â˜DS9XÍ¼…a<l—†£”³òNœ^·Ì®Ÿ~Ñjc¶q¥6Z®ó¼vë+7X·^_ëPIˆð& ’ÓMØh³:»˜w-Váï°×ï³ýBÏpUé“Ç)ÍM­Èb‹N„× ¥‚#òE¹ÍÏL{ð1)f&6ŸÎš&Ù;ã|*û“)e}Ó²ÊØ—–Ú¡ÔÓ˜…¶u—EŠ[Oä0ëóíÛû„@5¼À]“`[ˆ‡PN0ÔÅžä±j;M'776Ö°ZÙè%ß2ÀmRqç 8‚Cš‘o‚ø }ZÙÿq¯šcÚ¢Œ­7”o›\É£1ÊÈ†C”zdb*æŒª•ôGˆr6=ËÄ-ØÁPY´ôÓØ|™ôèàÉ:AŒ’oŒ
¥æçX|F;É’oØ}ÚÏåå‘žK±ÉÛÂ$¿Òþ‘šõ”TA²ízºu¦½íŸÌÀÛÅÝDHãÐ~onhäý#3UîÚÝóÍå•‡»öxžÍ(Q9uˆ³)±a&ÁéC‹Oh~ÙàÂÎº«Œ^–³„ØPµ\» 2¢5»n[6ÞâW;ƒAì@ìÜã‚W+÷¹€½)Ðh3Ÿ¸¯ø7Ãªì5ú)E}–Æ×‹»ã‰!k'†-ðU®£ˆ™Ó>†aRü§	3ÆC0xIG§Ò5ÃÞ@¼‰Í0äf#s_tWhûæ
Må·ß/v)aÃJ¹"1U™¾‚c¥]®<!6;Œ“».×Êw4‚´bo¥äê†oç²ÓÿÅÎSgä\,Ý××$Ô”ÿöš„“øîû×)ÆýÚ€^*'ˆoóû1²8@ÿR¤Øwä–×ïÉ¾ŽÜÿ> í¼	*ÞºvæòÎ×~¤ˆçÀ¿Þ‰:@ùÂÿëƒþUà>ú£F0Ò`ªÈÛ·eMé¸âñVû[å·<X¼œ(JTyh–Ù.+jÃ ^Ù-†4X‡ M ñç0%´'X “Jl$ãKja‚W§a'jwÒ9ëƒ$6Ò«¢¬yÔoÜah˜ÿÉlƒNÈuûÐèŠMŠ>så8°‹±LZDÄB Ü:c™¤~ ´žù¥V§%¼è¾Ê.ÛbÖ÷hë‰='°‹öŠByeËœ= 3V¾„iCè[Þb¤©¦­ÔÒe¶K“j°ËR*±ÒÊ³Rï*#±È¨:Ê]ˆn×¥J`U‹ÓZåà¥J
Â‡»w©ÙÏa|ìg”íƒ†I/µ)ÏÃúÂgÕµøöq
Mepã=åT­u(¨•ÃVH±½,ŸÏ­Fú'›—¨yå‰–AWÕ[ƒsòÞp‚öªâUÚqÎ÷hHàJFVFDüSå¬ª$­²ž{	
LZ?°›†C[P›0´ßn'ü/ejV˜Ã>·K=xƒÿÑÁ„š7Õb/ƒ»ÜÔ»oÌRâÎÁŠ”s%Ùª¼îÅL°Ä¸ù Ú´É:‘®ÖR[Òƒ7øÿúµ#Çƒ7îßæ­îÏƒ7ú/S/V`¼'<O€ƒ l½±K‰A,YOöz_îí?ùòD­3Bvô^&·¹WÈûóíªÃ$Êî8ŸÍ²ÁñâB>Í$}}RÑÀ€ã¢­âÁ›õ;¦ê4Y\ Ú•{Êóô™5GcúCü%í/a#ÔˆJáiœh©¶B+LQšúŸà]€›1¹ù¸¸ÍÈ¡tî\¼`î¨ìrc”“Ô»ou+¸ùå/p:ùWÜåDïdÌÇ»ùô¼x•qZ·¼6oEìØFZÉµ“1+±A€Ú³ÉÚ"·7œ­Îe»õ8…­`€Áq¸¯LS‹³üõ›Ì¡ÞÞò–V†K¢™¸%Óµ›NàïN
@¸ÌÐ3%´þÝcèá¯¿Hæé«ì0'‹A@i¦î,ï¿"Ì%’ç‡ôW+bØÄ[úv*¨tÿCµÝÞÈGömnô˜þèö©«ë5ìË¸V×?Ý¸ã=ÿ’l·Kü‰zA—#1t×Î2ÙT®ù*Ž9xšÄÄFz"‘P8"¤ÌbæñÎÿuîÝ–-J¨‹qlmú[–”žpi>Eçºx#/¹¥
ïËb’ ¸WÞ‘5÷ÙŠ²n{yß>¦3¨¿·­šÚ_({´×ÊvS£üÞu½bÐ+ï6_È<Pç.ò–òrÍóïT¤…š.¶nñ$IyÑ Úê®I×j‘!Øß
)u#rvÌn¼X¬ÉèÈ)oxÝ€ÚÊöM$uÏrkwŸA4ÄD±.'@ÒRè–Xê/—Õ Y„»ý=>0Í·k4{ëmb¾¡‡Ô;±ÝøÛ—_.ð —ôN| dû¡3ç"áì@Œ7Ãcmã¥ÿê¤Df¬ì?ý¼eÿbÊ­Œ­ÿ¯9ýO[UÜÖ¨Cr>”™A½0Ó§›-XÊ<‚dª3•=jØJg˜¤AÖ#˜ó©øªi¾í–’dx­áuÆ!o-íÊ1ÿ]Š^Äq'êŸXLM6ØwõÎ´V3)í¥T_*€ël¥¤«b®‡ˆ~†°æxËÊ¾µl|¾‚	èì
«9p*<ÀÐÒ´”Êý‘\B×”cëB‹VÛËÛ3ÅŽtTÃH<‡&ýI¹ØRÎS²LðŠ-C¯	¾Ç Ø™À«Ûñ>û§_]%ž÷	kO„çnÌ +h× ýµ?òÿ¹ª¬XJ€ñ\õÓÞÓž^BwxN¬ôR­	-€Ã`£Ìë—i5¢ëÂ1WY®£b³2ßÆ…â(Ù5#¬Ý?N‹ÂÚŽëdýKAjŒæ©k¦õ3Ÿ5Ã}L'ÙyèÐ¯"¦dRQØ—Í†®QEïÆ¦5¯^+ê“I`‚\Žv%qÑBŽq×"O¤˜Ë¦ù`÷oMZPg›+Rm©¨É;üšÑOGÝƒo’ûžù¤o1YnÇ(,zùRHLV±þVëXêQGj­yþ%­0bÜoŽ¥Âˆ+:¬PC»b*	Mî¸`JqxÅvï½g»G¿?<Ùþ¬÷ÕÞïÑ£:l°ã¿õ™'˜záÔ±X²SÄ*M¹B[ åK œØñuwöŽ»ò¢EMµyqø½]­¹¼)çL¡A·âƒ~‹8Ç~lµ.âxT>Ï¨1ÕÔYñÏhM¤3g®3Òc"åºe¸Ñx~xVôAÖ@*yÑ²íÄÉõ™æwÛ˜#¢mÚé¾˜?ñù¾—¦1€PƒÉœ*Óþq#ë45Ì2Õþç8ÓíU°¢GÕô>¾qß[[ï‚ÿÿÿîMü÷ùÝà¿ü¬øåýÉ+×ˆÿ²~oëþÆþË‡øEñ_666îÝ¹·¾~ƒÿò“ÿù«~í½|ãªõëÅ_ÿwïßõ¿õ^zü~æë?˜ÿnÈ÷£Âÿü ü¿{[[7ø?æw£ÿý¬Áúwêà(~ þßæü¿òkÐÿ6?ýdóÞÆþ÷“ÿëÿ=ìþW­ÿõ»wÖ·ÂýsóþÍþÿ!~'<ç”/êpÿ·âàõ–SÊg%c­çýWxm]’‡ã·ÜÈ·’²‚ì¥=ÜCð)ÊW¬3¶­}üq‚éNÑ-meåd”¹ÖLÞMÁC#-ÇàHû)‰¹)2{cXòùn²/ècá2Uä)µ8#ÿRº™Ç»—¤ÊÆr‡ÝH¥ã¶Æðá2ÇKy¿Ó€cËF)–è¼•òÒF™
ÖÐ®Œ—“K‘9œIábøÔècxšDïe³dn¨ïœfÕôhjHy‘ÇIZ½Ú¦&ÿùÿáß'_gcxKÆë+Xà¯VV¾&Øul¿š‘’¥Œ O£%¡é¯W0ªê	&ÑæÙx€FÙ…²å{Tj5 Ç¯b´ÕÃ²¸°ì¡D¿a±¬\›++‡œ;€©;àk‚ulucÛÝ¾Ñ6€hG(M3Å+­ìùSØNò9Ž éþÃÏÅM†Éôfå Ä'úøìÕÚ èWkx	:U·Óü¨ RDÄ÷êP¢¬hÅ_¯´~uª%×æ€ºzÁ(²q£\_ô3ìëÑÙHª¤þ=`Vã”¹„5 ÝŸ!q6·•ùÍ¬„–šN¼Û[]yŒµ³Ã“0äõi].-9-ýþïXóHIä‡6º\—Ã7ìf*˜”ˆ9E~p˜iYÎp&r(ªªcëÐˆáu5ð”w£/JEÖ~“ž§±|x	ä­ÌŒ¡X·¾½HÉ8C¶“6~3¤ûÝíäk#0(7_¾?tm‹Ôh_W$ù³MéÜü‰Àlß
øç™-ÐQB#ýVV¯Ejƒ¥­¤oœ½ša:Ê]îÖu¼7§¶@­7{fñ«.%É¸Š¶ížmª–²B·G™ÄÉÝ$0ÝÉU¬.lõm¯pÈ´M(9+3b•*Ÿc°³M'
’sˆ¸È±ÒÇÀ‚‹™YÙô</‹)ÇÐLàe#Ã×Á¹Ãüla‚s79“f:ˆ²5fÙÎÛõu©[Ú-MjABÈÒÀß˜7v^Je';3yºM‡„¤É…sÚ¥9ø¨é'’‘`>Ú¶-öÁ3N)×2ñR¿¬V±˜ÏóŠÝûØûØí èÎ‚ëãÖ·EZù9îˆBõ•™¬e²G–ŸÞV/Ã»DOïúÿ-Átÿ•¨ù8RÅ¥fî"Ç#iÈÿüÿãÿÅÇl ¿¹,ßUºÿCÂxºº*üÙ¢ácC²ž@ŠçÙ¸Šµþž Æi¡?§…¾%ÃÂ,“—iå$§Ñ¥ƒN4irØFÆåAw¢¦YÜÔ>²ìA cQ£ä®Ó!sêY6V!ûwMýäÅïÁ ©`ôÙ¥žÝØ<¯ƒÌqÏÖ5‰@†Å8F‰°ý P7ø••¿5dÆœQÄ*§N2[Ê§fú¢£·XT3òìËm	ýt–µM²7øƒq?s‡«N'PÜÓÖH^”]Q¤·Å••‡Ìßå‚3›b[å¢ef¶Ws²àŸ~Ÿè…f—ŸPYsÞ\ÕJÅz¿ÇRÍ =nÃçcƒôU÷W-—°Á\ÎsD¥“ìÐ@V.á½9ð>j³cÂA1Ì€™ÃäZJ@yPˆŽ)Ã¶E2åƒ(øiM^xB5–RËZ«EXËÊ#R°&ÃâáBLZ’6VXØÌ´~uI½$šªˆTMI«@Yé½(«jÔUÙ_CÊ"RlÒ"î@\ŠÕ• %Ã2(Æ¡Ã´VT‘2•)'6“ÄÍßÇ`cq ¼¦$#9i ­P½ãt09BÍI»F.ûdà°˜³y¿»JÍŸ˜”«Í]ü©MX@» ej3ÜO¾ªÔ„ÅüPmxrW¹ñ»òõtÂ	Ë¬ã–CLxÏ¡¨ƒ§—ê˜,AuÜ’Å«ˆ…h½98ßzüGD‘+T‚Èà˜Ë×è¡D,	ãÉ«j)88§I Ož8³ûƒËŸ±Z@
13O‰Rî¼‡µp §Ì…s¸H13=·o[6DŽó>ÏÍ
Ï›ÕÍZ`rp`I•œaÜP  Ì(*“9ÂTF.­5	$"ï3ÔÑ	hG¤ë++Ï‘„8z»2Q:ò‰*‰.ýÄý À¾[d’~’``øøÀ&ÙqS?FÈX„—œ©cÔÇXc`Ê³ËÄ
ËÑ(¢y‡ð¶´JL
ŒLä»ÂX7D1±ë‡Ï¥o„óbÖŠ¿ý#’7n¼^6mÖ¢ÿ=@˜¢‰W1ˆJµ¥¦?Ré»TuË&Q$Œx6Ã¢)Bpóññ	(CHÀì‘´8SÜòº“_¡Û^1‡YJY;ÍVvÇÚBù—˜žòÒ—€²Iêê»bÓD„„ÞóÊlŒßrœŸ‡ ‰bùÇêlþépï)M)1Í®ÉÀ¦‹5“=à	±ÕØ¾Ä±ÓØn1Y¾…3l:Å§Y
ëvÒ»Q>›á´¯ÙkßšæÌ™·ë6$I ¾ý—¾Œ¸ù}ð_·g÷ô÷öw÷ÿ¾»¾¹~sÿ÷A~7þ??ëŸsøyràÝý¿·îmÝ¿ñÿù¿¨ÿÏú'Ÿ~º¹uïîÿÏOþgWýûqý¦ß»ûoÞ¿wÿÆÿûCüÜüÛðÚ°ærQþßxgÿïuÊÿ|£ÿ}€ßþ÷³þ¹õ_Kÿ£É+×ÿ ÿóÆæÖÆÝýïCü6>êŸlÞ»ûÉú÷Óÿ¹õÿ¾vÿ«Öÿ]Xõëáþ¿uïÆÿûƒüÌücÚÛ|°»\í˜2óõ“Œ)’^çx€rçYYQnÃõîø“¯[9Í8!ÛÎác&Û=„ö¸m¾EÞò2®côæÌYë¼}k;ä%š³þG++Î2¡”îÛÚ‘že0Œ\àñ“tpŽjÐQOA
x¥˜ôtQ¯?±.ì¹ÂäËYL«œOr¨ŠSG“¿0þðF“û½mû +|qÕ²)\:ÉBÚà]˜ñ8¯|Ÿsƒ—ú‘ßl-	Ø±$ÏPy‰ÑÙ£o“¡Hn—tâ’ómzD1ùŽä¦ËÞ
;xùò ÿË÷&­oÐ°†Y¦©ÁÜÔ˜o,g4¾51°õ¡?
fwA·%Ovð‘çÃ!fïu„0i["œ¦"ÚÓEeAÐŸi–jÝ7S¨|t×eªL
Ž6æyšù(/YZ"àäÃ	[g‡0¼ÉdIæXšý˜õ$£Z§"ï’{NZßKËâ[*N$üLþ³ŽÞ{ì™æ-M{C¼·HÇÊ1ÑÊ,i|®@RPis)'­ot“')q‚»¨tìù¯sÕúè\á­Ó:<z´J	²¥7)wiªØI ¯éé–M·}B¬ä|%½oÖÝd)¯\
zi×Ë´gÓ\3‡Q¯ƒ¦)R1.€#û£Â%X4- Ï¹,ìš™ö!PãÒÑÛÝ’£ë„}ÚYBi¸ODd¿‹Áä]®ËU}dª1ì¡zµüDÌw¾é&_“$ú}ö´&ÎÌmîZ5Ÿònƒd/JëÄÝšÏÛ)ò½øõGþÐ7»Éçý2'î^¹g_°Sj™³Ýø“èõÝÈ¼Ëè8i“tŒn~TÍ²\-Ç;qÉÓœ¾rV¤ãªûùšß¿¯ìÖÀŽ$c	jÙN¾]²£~»b% '/F˜¸JRHa“²»í™—6¿T£ˆ<G¶¹Dšsž¸‘%AVQjuAæôÇ˜4é˜]n^e–ë»ôeÞ˜ú‘ñÌêvt‡µJyZ)ùDI“oßöäš*ˆƒŠ‹ò~Ó3ƒ­¼*±Q¾ Þôd×3RôÍq•Mm£ð)÷æ¡Cö\V©^UÀ¶}÷¾ËfÏ_Un=NÃNrÅÖ–ÿ`ÊW@xÕ}Ìq§]ã9Þ¥9â¯Ô{ß§æÏž`¯Ó¡>ÂM-05Z{oüç¡¾Š·«)½çÜPêÄV>*Ð€]Œ‹ÎW¨Õ¸Dók^—Fw³«O´Jµ./¬’Eí@±k‰ü/6uVªIž&ü þ¼Ì_ûÛ ¯ÙnÃÊÓÙu8þÄX´ZCÍ˜Û È¨"(ß¼ù8CŸ1kOÕ›Á7oÔ«^?Lÿ–§P¿S¹QlØ†uØ]€øáÌeÛPUÜß‰q¦goß®mS™ÇÓŽã^;žÖ4FÑL=Žf
[ôÞÕ›7o*ÚÈ›7kHÊˆŒø˜µ™_aÞ6Ñ¯Ï¹Š"@2å¢‚ÂVáé	Ïz–ë¼™yš¥%ißPÿ\ëG\s,¯{}|Ý¸*O@÷G•]>'õ?û-¦gLD	’ÏŽdÄ¢ƒ 70qO{&Û`”2)!eh#;·câÑ¯~ûö‘‘5üM+8Í‚‹#[÷¤L°ñ‡U²+nûÙ Ö‚uaÚœcy,®È t’§Q¦waå‰áŽÃZŠÕš	¡AŽIîÎZECu'Ï˜žNô’á\rÊ,rÓöý.Ít™ìÚåOËf´}­­Y³‡áÌnýWßƒhÍ)ÛüóÍ–Ü½uØÔŸþŸ›ô§tÈôñûŽý©^û/ÛL,ÂïõÂ3ý²6Â›ò@8Þ<Ç§öúü‚e1O“mšþØÐMâ3¯¹cØ­DÎQ¹
þÎl{ü×†÷WÐ"=ôš4ù¿'yUÍmkôÇ†þ#hŸyM¡ébjú†.´¶1úcCÿ4†ÏTcš›j™:%ªY¯5ÞôYEÑT/gÑõÎzAGì8‚øU‹:ÒKéQ+/@•bðjî¾n-‹¯¶è'›ô:ù)~¶.‘,y1êÃJÎ|˜äUOvp»¬1ŽDþé‚LúE™­%‘¢;ËÔuúWI5Jñ°íLc4‰.ÒèÂ«[Û!A'o"ŽÓñ¶¸~-èXL—ƒl%QCS§$yÄš×Êázârëb“.çBØ"’¡
»öb.Ij%¬Ä2dcXÿaC&ˆg×&àãDåˆÍMŽØ¤RV.×c[Ûä9’§éó êq99H®yåüO¡õ0öþïk¥$Ùð÷ä(›€ª,„V€±ŸŽøªÖÐ>®	-ÿü˜Ï¡¿9~þŽe^g§Ø¨u¢î5é£M™ìKX]d*ZW“Ä$n6Ãø8yh,-6§s+™;G3Ñê•í-ï¾K}UÖõ$Ö¯fçÄw‘FLõ°!S>©"Òd)p~·–X»u
Ì²ÖÇ|·kb'+«:eüÌ ¶/wŽûé+Ù9ëcñÇ#¥Ö\uYC.x+lÈTE>èRæ	~Êg>U*+›õYÈÂ€¿ˆ€6‰·½õ¾¨È¦ègçëW4þºpº,©9MÏó3žZ¯æ3û¼A„ÛOË5@($194mÜö@˜‚µ(e(A«%KšD9geíÛóÈÆVç²Z=
¬×C#ï‡{H—Z0,Ù¢»B{b{f¸iF‹¢=:äf¬Q'R“÷NÇ×´Äƒ³Åß…²cºBuzÉf oL_‘~Š9³ª‰¶¤úV¼JÏ·LRCÈ«4 uæ,ÕLëIqT,0ç·:aÓ­,v|Ø³JQpš‡A?åAÃZ6ë	ê§p¬ãGJõ¥z¡Ìô­…Øüž,Òr 6Bø»w†Š³>¿«Tú¸–Êu:>’§ùi‰ù‡Â±ŒùyhMí¿B€“#Ö ÚÕóL`ä>U1&îÓž¦ªKï4E^C+»¼yã²z±¿öâwï¶¢@lËJÊiÕ *ëi¢—DÛDÛRF:ª×ÝÙ¤¢ºÓÅ²¥#Ÿ>fDELúnhÓ¦Þô¸“]âroªm§ÌLÇyþÈ‰ûcL˜æq/•» ŸÙû°CT¹˜™ßõ£&–WÃ¯g†5¦'OÑk”€œ’Ýclhéç¡$Ëèñ|õ(õ¤O>Þ¾8›¶ÜÎÈåkqºí¿ ™?¡yZ§ÚXì¼’i•»I®QÌ¯n¾ëc<ž_ÒáÌ¿Ö©øiŒ§œ2ÊMf˜Ö[äÍ‹ÏË”NGéek•,ÞNeV,h$iUÛ$ŸoG0xé¢ösÍŽºñ|ÑL­Õæ'å=õ‰øzzJ=—$MbªÆG&XüÊn—h»"ÜËO›– V4N+»Š \YHgz"Áñå´?*‹©î„—àao’aæ¼ª§yÓ²G"ãã±ÿ¡dËÚT¬•LæUÏ¬"ä›…Ój.ˆ^²ÃÀËvÝ½ªì#=p2{ôŒ…£Auã±³¬K~ÄçªúdØ5¢RÌ7.mî¼îZ!¿&ÕxR¨¤õÆ ž^G€Õ¥.Ö'Ù¼ÌûxÕÇ.R¼n¼¶øÂï»E¶Ôh¦Çð\Wë›ëd]ï€;£—(åA—6HúÏqñÐ£ÞÜô¸ãoßNt=9q”OÝÐÕçöñ’&ÈŒYMEvclk<Ôköð…_¥?[å™›4Åq„p¨ixÂp{CÁèrésž åwNõ}XÏÎµ¶aÞ<½zÜso);©î”×ÀCÌŒ¶¤>eNk®N¹—T§äÙñê?p[~¸ ”°õO–Sè,¾kîíStWŠÖDG¦æzÂo¡bõ„ë–ÐÊƒÖ(ll†ÏëI+ÅkˆCyl’¥èùT¡ qŒzþõÎñ¡qÍ=)fÉú9RjònJKÅ‹´Ô”ž4Ø\ŽRÑ©v¶‡™}W;ß¡y°ŸÖªÑQ/®&‚F`ºäÔ3´ž!L³.Ô”yÝŠüŠF.ØO__Aw4µ	à¯!¬ƒƒ×³"—S@”^í÷oFtß~àªö)¼/–Óëõ™Å×+¿SOŸBô6»Œ.˜Øq~¬ÂeK(ÃÚíuÄuÐŠ j”æžóTxß«Ó ÙKz¥‘xI=¦×¡m­¹³Z’MyÑÉÈ‰]&2L×ÿÃ•¾hõŠ#^@é}å3-ö½'Ý‹m£‘*²Æ*éE©©O±êOð:4ZóŒÞÔ*ý(F«w ¬F‚¹S±_Á…cµö6ö‚òÙF-é÷6\Ë×¢Œá38Á#Ôô'è«Û8à/ ;^WBÐüûê¹ç\5ÓLCƒxáGŒÕéQ‚ñ;ôþçÎÿÙl\\¢œi¶Ø"ïhpõ¬Üpòawm÷Q[áŽV‹Sòé6’¢ÌØÔÙ–I
ÖO±Þ‘Ô[rhQ.¾-Õ§§qM°ÄÔîžbk­³g–øÿqU	t°
ËÌþ½¬¦Q29Ìg´½Ôtvó‚›g=}&Ïb2+ß¯gxhYMÅ(~eÇ	KëãIñ˜xÁµäü¶‰Kzª©¥g&ÃáÝ~è%G·V‰yk²Âr{»)z˜ë~ØëóC¿B1Ÿ¦”gE¤”ÇÑÅ8)¦tI›yqŠ·|âñ¤Wã-“ü*y^+µlAºæße#ï—i5¢tÂ…n3Âóœ,tP§÷…kÔH"–º]úì‘ù¬ÎðaÏö¥'7¡þ‚ÒÖû	Y\î]Ïõ5Ú"l³÷1ÕåÏh±S‹Ä³S‹‰fËúsÙ|8zZœÕ-ŠrÌóË8³åì¤Lûî>‡-gsy¶Ì Iôx(XÏ!a0Ú¥g€ msÍÓ¢IäÍ‰Ð©«Äðìò ôCµuêeñð æ=ÚŠ/_õ°ŸyaÑ$	/¹`Mú^´RÀ	wÖ <òZX3
Mt¨jG> …Ô²¯MàTÃòµ%Ç‹@ù°Ó‹Iƒ l¤%gDàýÇ!`RTåB0¢:Ös¤–é$ÃÊUNmP#.h"ÆN„ÜŽY¶Öpyýò‰lbå;CîÔ«-§µÇHviÑÞzôÈ0‡L0»©šd$hæYÇ¶Êt–Ãqqž5SgÃ£^–d~h4XíÊ?LlªŽ•#X6ˆÑ¿O‘wÌæ±¹ögãô˜Éµ}XäšTWÌ3§Ñ:*M¸(òq,Å@”Ú­/¿ÌUë˜$ˆTùí5\v ÂâJBgÓô”n]®·¸U™¤Wq‘³Ù¹ñ›ˆwÎ$p«òáü%‘C.á´±Ø& ~ýV8ˆtr–ëÀ¥ùQ6Oóñ’°'k*©}¶1<³îú?à¯,“Ãr¦¶­W!W
·¸‘Dœ‹ô>âäY„ØlÑµ¯äÖ¦89k}eH*$È³PèÎEšxµFøàñ2ñ­ýqoÓˆ
!L§Ól/ì5u_^× -ãM4™ñû˜²ƒ3ª3E5O«^üï8·Ñ²y‚Qé)bD¥ëxw==óeš:Äi¹N;§%N¼‰Tèûß?¥—Š`_ÖZØ- µÕHYqYoOš?Û4‰P;2î$äâ±:Ù¹Ü¬{Ç Æ…+~ÏòÏËeÊØF…Mtsbòb{¥m¶»QÄ‹Ï™–x‚˜3ï\y¶§eòbFpü¢NÓ½aÉPù˜±¦sLÏ%ÖcúžáÓž	ˆkTÁ½#¢‚36C¯‚¦‘£šÃm½ü˜Ú†&<ƒ›Å>Øó¦7Y¬ÈúÄ= \$@Ès.†di¹U5(DÎXæyÏäð‰{Š8ˆGÙé¼î&f^ƒ?G¹ˆA†óodcE´0,¤/W
MQªÌ$DRQ.ºy×Àõ×7VÙ[¨6(2(²Ø¶jsh€’€¡?%¯ø~@Åãw:>ôì
|©p†zæíÓ´šËÌ(°’Mñî˜É£¤<|Ž¥%®
NŠhÚRµÍ7æ~ï|zÿÒÀOò‹àÎÊÁü%¿wÇÿ„‚›7ø_äwƒÿù³þ-ÁÿüÑäÀ•ë?ÄßX¿·±~ƒÿù!~qü÷OïÜ»÷é'ë7  ?ù_ÿóGßý¯Äÿ¼¿qÿn€ÿ~ÿÞý­›ýÿCüð?‰ša?—Bë­üXØŸ’CSÙ?¢Ëm‚íña?¯õ÷aA@Ñ<ÿÃ°?ía*õq‹®5²1Ð”»sÄB”E>À²qÜÖ6çÐ ARÍÄ5¤Ž©)Æàl`2½–éôL/ñ“Ì!.¥»¦WÐ¢xTV.ŒÙ 'Í2?eóICIMÏ{î"@<”þ†î«/~‡å¼>ªè¤~µ$^ô ¢:ÃÇv´³%kÅ”jhÓü_€ðIw2:[¿öpxÈ[‰èý0í¿:+‹Å”l·¶\N¬z•äC‹¹õÛ‡@"ÂØEøÈgÏƒ¢œ°Ÿ=öäéïUÊn›~¸˜šñ‹ª–šö©¤•Ïªc• -ñ~,ƒœAÈR†×Ð‹	Ç¿r”OÝW@ª]¶¸8ˆƒ—‡IÕ/0ƒ±ÂƒZ¥ÐGNF
A†ÔŠGl„/¥îµ“3Æ+¥ôÝ‡R<ÿ™ì2O^RGËž2YôÝ8õJ—|ñrJ»>+fÝò‰Öéb<Î0rYéÆG¥U…cºûjµ’Özg#™¥ezV¦³ZªƒßV.•U“–ê*”H.0(‹®P²r‚ü|ù s¹g©’iAÉ“‰ÞÚ›)
¡ÂTBêŒPØ$ÆY`ÙåŒé_¢4zâ¿¿œÁk¦Z©fßx+á¡OÖõ„VkuÉèËL‚ys9-). a>L)ÛñÒb“kŒL:7êßIŸÚ™
Ö°ŒÝÐÜdÆG†^ÐKAM;Ãxæ’¸YÓW×Ã®´ F˜*•fÚHHY…´€qÎ1>OñLÎ$*ó³ÑÜ2P›› üÈ'Åm’qÊh20÷ÉÃÜ1.ÎBêì2Û<Õoˆ*¢.kÆ‹	ðQò‡G°”ÚÆÐØF_ƒ|ÖN0b (¿‰“‘<e4;»°²1²I•:Ti/._¨ô…DàinÿË|ThÃŠ¢íºÛ]i¦ËiÊÑ.+Nãu¬à §¼‚l¥/¾k\ë‰¯åhLE›:<f|~ô›î‚äX.“mÚáÏú*êV°S_¶­zÅ! t1ýÚ+q°Ê˜„VÌ±`Õoè Ÿæ“ÅDkYäj8ó$¤©jf#c/ã—ý¦«gÉ « ‡ùÜ&ÿ…ÏÿÆ<k'_g§ð'sç7ª)³¢¡%¡T\³ÕdÄmïN´›ÞY‰~P[Yíß”¢ClNxÃ×ÅãåZ×ÃÆ­Ý×på&`Æ:#þ¼ª@>ëMÊ“ç@-ƒáuB^T=Ø?{2ÝoßþMÒâ§ê+«^M!ï6Å@£÷!ýI­¤³\Z0OZ	‰”:qØ[‰º¬ò?/á-ˆ9"ô§Go‚kÞ/Órp·Eš3±öH^ÄqZ¹òa]÷Þv¾ëújRÞòM™¨C‰ÕQ#”'¨!<ÒG‘ÀÛ4+"JFÅEpÓË{ÿiæÎ5¬º“z%[{=P.þŒÛ£UØfÕðsn¸gRg¼\&-aªm¸ºt¹¼‰=<LÏJ„¬×]ÅF2ûª§é4ð0›§6ü =ÍáïXèAo†nû!iLê@
'ˆ_ôŒ36½úÆ—‰‰½Pß^vÉÎUÐO¦çÛâ¼Ï|·i+¬ÉfÃ?
_û¬W¦Ãz¦A‚Áãž=-¦õ¨öÁÚÆÝàðd›hP¬»oÔzM¥Iëš.&§Eë+Ú ¢ó×ÐÔã£ø"ÛCÿŠ¥…4F‚UkPDØ¦³×)ÞL‡Æøú:¨q#®9ý…\ú,Ø¡*anrÙ»¾¬K>ÒåˆêOKfÚ,mPYÑÙŽ¾nqè	ƒç!ræxÔºò	JÐtŠéëÉ›¡ÞÜ¦ë¦Ü*9Í>Ñ¢ß§Šký“tì?j£ŸÀ­Ìé|µÞè]ÝG£4Wó°Š	'õ€/‚ã$-ŽÌ¶‹”å±\¿<ƒB?
Ï<»Ó4-Â8Ú¼c¼ Ä*p%=#&BÁ¬²Î03ÁV ç& Ü&®±N4‰sÍµFµÚt?#öÁq/å¦ð œPkýÎƒ‡Ì8"òÐÒ:.Ò>#ÆyHn¸—	!ØŽ‰G´I2w©”‰4s—ûC•‡û -_‘¡UÖ	a/yBè4ŽÒFŠÁÅëŽ;´û|šúÄùÞáãi)ÒÙÜ¥æÐ&ÀµûÉ9ƒ.'S˜mÍQV@JI=7Æ/a[U1í&‘kÏXã²‚Žv™=Œ—lÓYÉWÆ=ª¡
]LA;þzwçI²³cÿÿ²G½	±Î¦0ƒÊhÏ‚•Ä“(KíäËp»ƒfIžØèã¶4E}S²ù‚~­ƒüŒÎ'Å¢?ê<F«^;yòÑ¿ÌÒs8K¼ÄAwöÐ[9ƒC7®òÍÕtàžÍ1súÒÓÞP¶Q”äxìYe”“»ðÙiFù¸¨ŠÙÈ©„MjœëÅ¡­ä…à,^÷\sÁ9ÁRˆý‰Ùýjô¦ãð`#ÑÖ5õe:^Ð•	¡ìX'NimÐâ#ÌB-YÈ«æµcçµÔûj	ÖÊ6)Í¤³®l>æ’H¹-æÚç@Ý‹ÊmbÜ¹@O)$ž0¨:šA½3~Ø|&¹}›8¹uŽuÀvPíKR0EAŒ£]+èao(ƒ*þB¯CSùmþHcó«0-«ð˜ì×¸ñ¹UJ˜B·ôœeµ™¼M¼l®U_¼,.
0Ä‚âŠûê‹uŸwÕŸf‡wæ0ˆ«[IÉÕOÒÓµƒlºÁ/^˜káá_úFNP.;fGcàÙš¹ƒ9…‹©_¢ïm|¾£r—*Ã-]®"¢ö,ë³a†Ì²¨òš„]ßÚ	Íö(ßm×!l®ÆîÆP’4Ü[Î¾Õ IÃÌW£5‚â±„—lÓÓ¶9Î).BE¶ä´A…Ö¾õ¸vŸÆ"Ã yG?r,JËÈÐ¡#kcÒ@<8š"±ç-ÑpúlZI_x£¿²µ/Z€ùïÎ÷¶W‰©®\JšCLœTæeÀÐb:"‡2_vŠ¨¤W=Q£Â¯.à¼¬gŸ5UË+Ì/Á­<§7=¿óÆ½¶]Î1<µÞÈ_4·›ÙÓè¬Ò @ÊëäWQ Ð`U†Q“¦ñzê8	é2·À±ÄÀ¤ûP³*}±É
JãIv°_±@Å“wÛÓ1¨ç½Ô–Er¿YŸ÷caõ\|·Ãg4D§|¦/BèK®sr9+èZËW½æöqÄ0cÝî;iU-&*û?«Î{'(=—HVËðXâ2l¹À´9
]Ò‹ø‚²7Ì:[?‡è»ùm«Ù¶Èåâ]ïl"´³m¾›…ÿw)^*Â)b¿€ášÃCè:mªŒIÃt1žcCƒÅëµ‡O‹Ý6’áw(	µÞœPLk¨5eÀqJï‚öŽOÐ0§œòß>…>Â2ÂìAöˆókš†<h®hŸŽû4ÇÛBäx§(£îÍUAÜfª:õeëoú¾â±£ý&ì÷Bîï5µ¿bO´V[¯­™KJ¥nk²ír&‘vnï®4’“ÈõZ¯AÛüò+[¬áŽ£h²ŠÉ‡êÉÅ¸žËôåƒ‡ßÅØ¯–kþ^mQ>6‚XÂøä|´{´²¿»ó4y´·»¼ÿü^ðEf,h´²îY·ÉÓÓ¦lËøÿwe]™n¬^CahÌ¡h°ó¢©}!¼*õ1Ù£œû¨æ‘èÂCã+Ž;:û—Üü¾l&ÙX‚qåcí
öjÍøÊyˆ [T%·Â³K#à¯Tf<](T³b{•1†EDQÍ¾-àÆþ%ImÎ”4¯_šÔ§O# DMË±™TßW ñs4ŠßÒ¼ËT-jÅ€-0 Î®Ü“›Ëh“gú’@¬F«/šˆo¡W"Xê²vL‰pÚb:fÖ|dP«låÇ¾
GLÉÌ{ôºW^5éÓ¨ðÓm@¨®žêå"uâƒxº¶ƒ8®Rm´‘Ô#`axB‘gWKÖ½ÐWV—ÝŒ^Îm‰ýjÇÀkÀð‡y[ÈU×%±úÞ¼mÁ›ñtÀ¡ò n›ý4Ð¦ÕœïØÂW+áµùß™^z×W1\}Ûs	%/ÃSƒ†þ¾âj·Éë¸ùì`¼°M‡›‘Ã[+ôïÊª,9E§ÛÌo–Ü/ó¯Ô£”/†säñDX¤I³¨#3”[û;fˆ`[„ 5b7 û'`¹JS•NùÑ²ZW}gö¹«ï‘Ÿ×µæµú"–²Ø²™0îfõvLhûÔl[È¡8ñãjµÅ5kIºãpÏø†ç:ÁÀ•jÔ$È-&ÿ“—õ·&[Ð£¯YwceÈe|MÉÅ+µ`LÊìmbîd©!ë¥¯‰ÚæÛBãôuÏô8×UgOñy#P|(«,lø‚ÊH¼“”
¥«…-ööÔ!zÈ\à¦÷ÃÑÃã2Šu|©³TÇ¯•iÒâ°ôÞ´_^ÎâZsfß…â	?‘EuuêaÖ ¬_Pî^-ÛÛZ¿šþg]FÂúÁ­ƒBy¹Š¤^Ìõi[GU7ãTàê¡zŠçyÒ~AÆä
x£ï^ôfübâðêòýe=$ŽrOŽÓåJÌõf¢ ¯m­–ˆ•¢rèå'ã¸ÛÐ„qõ»²¾ÀÞ['CÓB‹<“Íò¾óáñùfÞ%OÍ»¨`9äl˜IšŒò³QgŒF*Ž¡.îñ3ìIÅhY;OÇ]öÂ·í°ìý»‰aÜ	ÀiE”YÐŠ©ˆ…ìÁ gtÏÚ72É:+ÚÓÆÁó‡ûO÷’½ÃýÝäxï·/öžíî?{²í—î0ÖÙ³ÚE ·j¤îæ(>Ä…;%-òC0Æ¶g×uÀPmÌº»ÑÕäbÄƒ áã°ŒëPlô®oMôcÌAÊ–%Y²Ñ«ì”Mìl%îN¶yc‹ÅEõÑf;ŠþŒÀ]Ê©Ú®Ìš’åØoh–‘QÜ£ŽÐòf{œ³þelÓL´ÅP©¨ÒÃ{ÎNòÏ¶s¡tóú+¾ÉU)ø’½&vé÷·>‚†SÿQðíÿÆØJ•DÜ&â3KT2æ+¹§¿±ÙäÊ…'9»8QÁlŠã…ÜZLå–AÙhÂ/Ý®~•H6ÿP¢ÙAÃŠ+n"œFÓC#ë¾k$Ö
˜0"ÙÞ¼ÁR=öd|ûÖüM%EÞ–Ù>‹HñL<s8Ï<X1Z“$	sI~ŽU’>8Éìº†Vœç˜‡ÛÇ¬ÜD <$¢“ØíøäùÑï“#hûG{{ÏNŽk2íX>`|ç,Ø2ÿÖêz² ÒÁ¤¥–9J;:¹qÆ÷ÎeuyTµ¸­=âòùb½›ŽœvÊ6  â*bËêðÃLC<Ý½Àr½Öò¸)R2Cà>Ê-´¦.;9*ŸCmÅÇ=G7c+>±‚ÙµeNcùH8}:Þ¾½FÄ;µAy<&‚k¥‹ÐZxW‹‡èÕÓ¸‚üîjkf(p¨Cã·oÛªÐ~rZÓGeZ—©
ÞáÜw6…CœÛ»¶TH“]›u6‹QjÇ1ån´ôÇiüåx¯ïÍ¢|Î†ÎÛÚÚËßxûö#¯™FŠÓ7š‚ïð×pJŒ-o¢-_½X<üÚÝß¥PÉ1fòZGK„@KaÜq®m€·ZkJï/~;Ê\'å}†MõæžûÀ iwépB¿-Ü²_ƒ~f"Ìê×""Ud€;u1Ç‚)§1_Œ²Ò‚\êèZ[ßs62$oÚ\½ bÒR¢•ÕçVk[s”õ_!ów€æ‹qÔ¼±kÊ$G\Fn<êûïÃ©†j:Þ›<¤¸‚zB›òpáÎ"‡G(œŸ_³RJÚ9Œ‚6c:¢‡_¾7œ9”‡r1Uû¼ç0`‡f"Ç‹>ûˆÈP%C·F„Ž 1œÍbÔ Äcûò*×k¾UG¤ôÉ¬	ÝyÕúÅ<â>Å@À‘Ü–r&R IÈ?â×O¢½kp‘  t7§žOa.ºWì‡6&ˆÊ÷†1°ÀíñkîM þQ}î“‘	Ö,c_ˆ;Féôs</xE-B¶’LT^é-å‰³ùPs¬‚Ñ¸½JGaŽlš›ó6‹…%m¥â@cŸôAáÇÅ•Hui¸Éœ¾Üïb9Z¯…Ê„®	ÿqÂö{uë5xüø­­˜×NŒÁ0×«E;¤€¾Ò-BÕ½FJÜX5kPö‡'KªÕüHT=³Ãa¥ï¬ŒàåbéG7\~§“N¿(Ð½yYÚò{Ú•‹úª@O€¬¡>zâÀ\}STwO£}É
£rýâY¹íücÌu©ùíÎv¨ÂÙdEî ¦oyÑ{õ¡XkÖÄ½PªNôj"ÖâáÁ¶R›Ä+¡z=u™jÉ#7FY4Ï‡ Ä+s/3h ¶Ÿ÷Àá¶Õ
Fö¬(‘B:¿ÃâBš]µÂLòßŒù/÷Søu{6EÉ{ûâ>nm½þóúÝõûwnð?Èïÿùgýs¨ÏïO\¹þCüçõ­ûë÷nðŸ?Ä/Žÿ|ïþý»÷ï}zƒÿü“ÿÙU¿öþ¾qÕúÇõìÿw6`ýo½¿.¹ßÏ|ý»ù·ù?ÎÐl3Ì³ñ #y²þB,ðwÏÿ	 nô¿ò»Ñÿ~Ö?·þkù?~49ðîù?6ï¯ß¹Ñÿ>Ä¯AÿÛÜÜZ¿s“ÿã§ÿsëÿ}íþW­ÿx¶æÿ¹³ÿ˜ŸN‰¡®ê\°bR€<±¯LD¿ÆQWVÿ3HÙÛÉœÂÓ1›ïÒMå‚Uù”#wW’ßçlÎH2öK|…&¾O•6Âú³Í3hQ®¸b_uYàÀðô}ÝËcì;Ø8Ê­8ød›ŸI,.—è{s) V¤ï¹7¨&Ë°{29ŸI„œ<€/ÌlÞ<^Á[{‚(ÍÌ)oô¶dh6¦¾I¬¶ý4&‹I@BÄÙLù-™þ÷0©K6ï¡“!’UÀ{’lž€ÊlÖ«å6éXZ…ï¦ué#s#.ÐŒÆÓ•ºha+èfÍ^­XˆxëÇ¦ïÛú¾Å‡äKŽw^î%Ï_œ¾8AwØÙ%'Ô¬ñ²X”æ¦ÓÆ6èÝé
Þ¥·‰	œ„7/\Ê›ÄÜÈ5ÏtºòSöLfã€l»ü…Ú¥—IWa×œü¡\Ç›«G¯Yƒ_S3é¼þ@ºÙµ*ƒLå*ÓòŽ]ñc—ô¡£fŒÖ†\/¹šË»­\è	õý§ÙYÝöAz™T‹3t—ð N(;Aó=ÚäÕôÖœo©dßN¥¦i"†õµià%öÌè0üMŒ«bt¸r‰“Sddû°HËÖ· 	©Ü´un5RZ‹]iDœ@V®í.ÏcZ$œ¡ýèš½[ÚÖ»Ù9¡¨8²«ø8¤îÄÑá$êÝ)2‡µùñgS=oàO„x€%J–43…I¤$o®qG-nŒATì¦IÜÀ¾§‹YHÞNNRÇ9QÓO}Ò&-DZ;Âø•Y1X{’Í·ÚŽzh—’«Y%˜ÃÈ)GAÈ(6tóÿoï[—Û8’5ÿó)z4±s¨3©›%›±q<àM¦-^DR–d†Ó$šd[ F”8”#ÎŸ=p~nlÄ¾Û<Á>ÂVfUeeÖ¥Jå±É3ºî•U•••ß—0t«=.Pv€MDî¨îLöŸù=ÌGü"Ô¸™6>ûc™4}ÃáÔ¡ô{ù©ç¯¡ÓööBt"…½· g¹Ç(œ5¥ª»Ž9êŽª cÃ½È¡ß<qYìIR[Ža#«"è‡îÏê
ƒ‡Ð‚éy†©U¬N`bÆø96Šwp7Ù°2=·Gã2@ë,‰Rn}NbJÔ;5yâ2ÀžõI©…„@”ðèÍz!©ƒEÅƒâá9mÛÙ‡!ÈTi0Æ±Ñ—•§sÒËÕLu;ÔàP†U‡úÞ)ëz›úÝô.Üà®ù¨Áèœá±Qðá¤|ïM³nZ—_rvíÎm¯#ˆslÓºéxv‚¤–ŒTvÃyÙù²Ëö¡l$Îé
¢[a`ò v!}Ëd‚œîMÖÉ±EW"5RU½`«t©‚+*+~B¼cÇ€ŽŒºî˜C.Š¯nƒïA¤"<?ºÅ°tÕ-«DÏú^u¬¦Ñœ& ]¿_ÈŠññâÝ°…\5,çå¨è#‰»ãI·¬–~ÜWèRsö¡‡?àÐ0ò2ÚÁ
†-{jé[y€ ]»ò‘·'¦*xº:ØEc;H§XKIÖ>ß$6×Öù0r)Ûjv_Œf K–6u9ûÛð:Å@IÁ[ú9‹T”¹²œe“¼‡¡7NuÎ–Ê™¡¬¿F
m´‚-}ÌgËœ–^ò%í\Ê~ä’iWµa¦2ãnC4x“Y÷½ÉÔóegƒ°Ý¾ÅtŠ¦™J¢¦¦hC"Ý–Ç©ÙµŽ‚‚W?Ch-ŸÎý-cDšß.ÞA œñ]5…u?ûçýwöïºñ‘¡Åø˜}^š”ì¨±Æ3$]xqŽÂPÆbµcµ`qÔpÂ;®ån%õÛÌ’¯³ØùÓ({(IÌ¢¯Û$g1þÝ*ýÆÅŽ5¼®ÖµF/tnnwv6w¶ÛÏ–³=±Ò S³.‹Z“I8`Ë¦3gu@KaI¤DR[x³¶ ºVyrÑíd‰MœŸÚÎ”šUÄ«m ´q½²k˜½©"Õ—ÎÒèr³¥¦ÜŠépÏZjM­ç±E“h7. Û‡¦QÖ£“¸b±26$ÁÙRø1çîÚÁè«Ðfà~Ð•€f(µfôÎGo­†¬Žosy¹cÃðh	‰OÔ/y|1ÅgÀ_PWš§G—ZÃ
"?÷†)ý%GyÕýjùk*°‚sX‚µ•rm;«ÛG6†–S¯²|·Á>Ì¥Vr³®¡ãq7ìY‘ŸÃŸ l'È¯ÖÏË’RŒ‹~L^ørÍæÍŽý_ƒÂpqçµÙJî^mñæÝ.D ´í/9bø¹`¨+¯W¨­Ð ªÓê4å¤@ÝÜôCÆŒ2êÑá'eãâoë~±Ñ%‹¤7Ê{tqUÃ¼è«¹eS±£ª~:—XìDq’“¢´•r0Q×xpj¡¿§ÆakñN$á˜WúL=ë<ûçóö]ÏÈ—ˆz² ¢;˜È;û2‡„
r•­šŽ©	—=¬ÐúK‚·âU}TLÙ®ˆŽÓ×ÇábEz´—(0%Úï-¢ˆ[-l"ËÜÓ¨4ìQæbcï¬Ä8ª¯æx	’ûƒ»¯XîŒxJ!ÄP^Ÿ™"˜I ¼Iñ9ŠÖãhLÄ›E‘4GÖxÏ„…GØ´;Ó{Õ˜ŽG•¡‘˜&ä	£Å‹%áù¸©Òä!f¦pM˜9¾ª•YCHù.¯Iváæ1
vt³{ËéC+reÁc\ugÄÞ…ýÉï£2Bd›Õ¾&wÔýÛß_|ë…7XÁ¸´Õ:åz®W;ïªÚâ}*ºòÕ,ñ8|2l«s0OúV&u‡ª47„Å àu±=x¸N~ÁHÑÙ`«Ã3ÙCÉiæ¤^€¹o9Â0n~¨´ï±iž_4Û¦OŠ‘föi²	Âµ–µÃ|ÁÔâ”vKˆ?Þ·Sô÷¿ÿ½_¨–zM`°†ì`ÍMßá>\¯–i¿Â›¬ÕúlåÐ\¬ÂgUYx“®ÒÝË³»”«˜rÍ¦¤ë¹{”dG…Ë¶†ÙÖm6zËK¾Þ¹¬ë˜u#RcÜxårn`Î§6gMÈFß¬î²<Å,ß]
ãY§áô2zù·Žtå;ÈóáuQÈ6ùëtb u®íêCöýá°Z&s37“©ÈeÛÄ~OÿþÿýÃ¥gPeÍûÁ5ïÙá^³™õ—š·uè›*ñvIŸyMr›~ØÆîÕQK–+dÓîÖýe[ŽZ†K¸ƒ	w/í>‹WULÃú¼ëúüü00,ØëOö{Õ{ãå„~ïÊP]ÚåÕÐeŽ­sÑ8÷ðßû—N‘ÔU³¶î»¶Ø*É©¤¤Š³ø—üBÕ2"%VÃ6âGÖ¤ÏEåG×”—‘Þ››Afïo¼ŒØúí%Öz@ÿ~á
ßñ~„Œ¯.µÙœ´Ö®W.ëëC_½[öåñ•ùÓ%R	í‚û[øýû'WM»RkDPðÆK­¬ú «æ tÉÛm½!¯ÌÑOjß]„ŸîîcêÔ¾E™}\~äyÀò8w#t²¯Íb…Lë‘ŠP-«±9x5òÎÖ²¡ólðZ¢¯Õau6+¯.xqp5R¾z|¡ú°²¢v¿^oùÏßÜ[_ÿæž÷uË|l¯­}½þØû¸Ýôq§éã^ÓGÛ õG+_yW›>®7}Ühúø”>®<^½ï}|n?Þ[üõª÷ñ éãkóqm­}omÍû¨„:Èªt˜ -§s*^ÂÀ\ÕWàYã8uV¬K¤	¾JVèÉØñ$R?TG½û\K“2(•½#™x8`0Þ!U?XÕéˆ:8eÝ2"¤\•×-¬ôÅ¦k•¢D­Až(ß‹¹ãz—]b¬Å±qÇcmx5”MÉb´gsªÁHš»l6X’t,Ý¥EiàìŠZÌös –ƒeß_×?u‰ç®úÉœÕŒ¢‰»Ü-j²4j ´–)p¶µ Waðð¼{!ßú<_;¯Bµ2"=*áÐfšD­@Q|¯Ú²ê¯î6Ã¼×„ë²Ü˜Y´Ü5Á˜Ho.Ó‚ÉûÄhH×/×„Dï}Í9œ˜Ø§ ß‰îÚS›âiâ¦%F‘‰ÒŸ/_¢æOV­@1¦ºÍL­ØWèÕíéÄÀ«ÅËú>;c´9ßêæØú°9J¸Óv:¹uÕbÏ±ZnÕú®V„bO}ÚÑƒ†l]æ6oš@uÛ2UG(ÐÑg{é7StTœÛ'w4Ë—›6±ËLNlµ–°Z¶O]j/…—jþÈ¯~Òõ	c¦Ôoï|^ÿ†ÿT;¯¸¤ô'a@>ÿùèá£[üÇüÝâ?ÿÐøÏkÛ®Žÿ|„øï[üççÿ‹ã?¿zðèëo>¸ÅþîÿüçµŸþÓÖÿ£GžøëÿÁƒ‡÷oÏÿ›øKà?cR0g æZæÁ=/on¬Õ»¹8tUÀ7J™O C™1@ðP;²¦ªMG•º#àaJ¥$ÏAš³4øêK18ƒÊXð.þ„3Æ„nhm³f
8Q_N¸S®låÝl«ŸU]•]››
þlŒ‹øÑvÁ|!÷Ý~i¢^Øè! AÕ	n£¸Æ€ŸðÞ¸,ÚÑé–5>ÇÚW[ó’}ÔÏ»­J]
du¬|¿˜nöˆñê¼¯™ÿW &EDêq/¯kâ’lð[³Ôè"%2âƒM5ã}
ß,†£¦‹Ë³þs/8ÅEö|•‚tÿþbÖV·B¸Ci‰`¿ÍæÏëì]qÄt¯¯³ÍZ@r”E&¼à!‚²§]IœTVƒâ[*á!ƒÛoèíêUÕ[¤®Ù}\x°&Ñ”_7Ê÷ÂB`Lš-#/…ŽuYõªÓ$ÞK‡²†ÃÝ-OðMwL’Žõªœ-mÂÏÜÛë/;:^H§½»+`åáÈ³|ë¯6÷6·ŸŠÌ+£ê]23_õü©üYû`cgo«³µùt¯¾°³Ã8£_08ŽÑî€ŒÊJx¹¾Ò9Ø1YBrµm@~#"ËI4jaN.Ã·
Rí^Ò9Œ„/Y»Èœ‹‹ðÀy«–p±7èŽ®;lOo¡av¹Ùm6³·«Ï…„°Â<½1”2Š´Cìì6ƒÞóÝ„“‰È5‰zKûg¢Eô}¦æ8Û»Í©[I†3P'ªi:FÝ j•£5®ZÖ/ä°–õcî?Ã¢³AzÔºÉ^îìý°ñlçe¶²×Þ^ýNˆæTÙ˜™]¼/Ž'ã"]“p)³æ»Æ“±˜z&;sŠ¢ƒ&Hdc<4œ3ëº¤4"Û†ë!r°ìê/6 ‰<[x„Ìì4‡-ÄºR¥N|”!–¤WE‹­ëá"nÌBŒeÅyÞ›ÈýòÑ¢‹6ˆFÕQYCl|<*ßSª¯³}_ÙA\`õ_]YàãEu¬ ‚{1éúo™ÑœÎa_ E7ÄÇ*i¶Ì©4½”ò^1O³+z€áÜ3}Ž"þužÀR†Ä­‘ß!Eão(EqW? JA"_9©$G„s3Ê’_¼®&£AqÁ½¾ÂÈ	Ðw;;RÚæ<Öó&Š„°¨ Òô?œç¬n=oÝ»J;AÝYýNê„ä¬ÓFA’ÁØh(¨»û±»C@^ý¸t¥-P
["%œH±Î¦pg#uq4c3ôïü)AÕ„‰€¬¤ˆ<¶ý4Œæ!ÄSCJÄž’ ýo…ûÈµM
w˜‰D'Hˆ3ÑË/¼×=^É”°~—ÁñblÔ^™9 ­v;ë)Ý¤4Í&˜éE'¢¨…›b:‘&û¯­ô”Êe4]ËD'jØ…¼‘ÊW¹;SDýÉ Í=±W'#¼ÝŒœÃê´F,®â9~ÕQ-a2ÞÿhÑÉV>é–®pu$chÌ‚BcúœÇ\èGãXŸ,ÒÖ[ÎÕPøzœá­3µwúFvÕàà¦Ð¦»·ÂI[]Mòn?Î¥×.’+žâºÃt}_WvûêlòæÄÓ•Ù²e6ˆ¥1‚Ql™cÇmá"²hã×¯ýZ¢ãõÉ¤fX¸½»$»ð€®>Šw F…µ@‡u_)=áÆm}ðÄõØdœû™´0éVžò®Þô•ëÅ«x=ÞìƒÞ)#JÞ ÔÔ·\ž6=~:çUorå;Š!$¢Ì3ŸÑ³‰¦l”('x¶	Í4-ÁA<ÎG§Å8¤kAñ³eÎªºë«º­Ú=³%‚­3¬Še~:Ê»-­(9÷`†ûJ‚Ì±l#)½’o)"d;ŸùÅŸê4GëêÎÖÖÎ¶;MWw¶ÕIû-?B¼¸[‡©j‚Œ«Ý}mtfá)¢~T[ì¨"ECíÏgÚÙ›*"!˜³âSÕÓ	k¦¡d\äi©r+=U‘¼æícîp>
¦wAd‡¼Œ£Ks ¯!X2…šµ#•×útô«c8ÁC±9
ÑÓªYj ÀV¨ûóqd—ƒn	ö·tßD2ÉR6óàbXìã;JæËEÅlèøxAh5Ý™aüª&V€3wÐÜA §”>Û0‹+R»&íÓ–ÀòPtË•ÛÂ¦6ì•¦-ÎõÓ7yGgõ{DOlé é.0ˆ…Ût?©å	å]NzåÑ(Hím­Y_PæÛ»›Ùq‚1sØ×³
oÅJ»SÕÄª°wj¯Ð
6—V×\Œ­qUõ¤²‡7ø†}'6¾%b-gå¨Û*•äBe÷ŒÞ>ÐGl­h(’ŒD}?EJ‚W**ªñÔÅEÙ%–ïc×óŒÿaL˜Ö	nÕè4È¥¦ßrÔ­f÷5vUyOÒ¶PÛËŽ É’D3b^•J²dX¢";C[m{ãTÝ«<èZ,"Ú€˜;£žM1åfíP CÑïJÓ®}@ïe©R#óHsýKÞ¢šLÃ‰3ðB6{ìhsÁ2#3}àG$œŸJ|ÊÊ%Ú¿ø
ZÈŠ…$wbOsép­ÐÃ„EÛ½’öDPw„’ÉÇr½…ˆƒÒo­9díGRëbÎ±±7{/Dµ}Qa-œ¶M å--Yð9.T$süXcMÓêÌUmÂ)º0,=ÄÁ¶øö£6ó¥õ.Â¥D„E®¯ø;ï—¦µ‰ˆ!C»À¨£y¯ç—ˆçÕ¯Ö.— —â€:šœžêrh[ª,-¤lYÅ¶*qÚ©GUáSO;ìª1Û£‚WÀZþRÎ(=$m*Ö5Â#M	äÊ\.r("öø¦ŽøFGÊ•Q«ûœR	íÂ(àà5C+ßEl‰ìós³ùÐfªªÀ}àÀIo°nàI½Ff/~¬¢ÑÌŽF=âêŽ¨jc¡úõ8²……Ìzx²EóÏ A†X®‡††O»ZÎ.²V%:Ô*ÕÆð¾A„Ã{’5J–(*"kü{T2-"|žˆÍ :úYÃY…Z‹“ë|Ë, /¥-³ ìÆ¡,¸¹>/îYcž;ê‰CM†œ¶!‚qÕt…û’óQ5QÙë³ªÂý›"Ïä	Xm¿N9”‰c#x››²/]=VV“h7oaW<qm…³(õnþÈé.¬u "s/mÂ˜¸íÕöáQŒ(ŠCSvBŒ0È;Ûü¼ÑoJ*©RO£"±gäÅœÎ[9¨{erJl8FÒ"WÊÝ(ÑŽ^KìŒåÀ‹•uBèŒÓ¤d¦ŠZŠ±ËœÄAAÉ[âìZÞŒñ,:%	ªigËVs°¼)§uéyH2„›šƒ£JÐHhÜFñÀkÚëãü€{úmçø¬ª‹AÚGß`];’Ï¥òF‰ühV·’×àp Ýá°Kg'ñ§2jjaCÐd
	jöì!)uR4J‰ÅšBN"G¦äSYÁDð òŸ1ñJ¥Ò§¸EPÐ©¾µçwmúS(-V&$Ù	Í?ÿÏÿrOFšhHŠIæùÐè,òpÅ‡C¯dD/ÃZÌ¶ì¬ì^j«’ÍÍx‰¾qLÏƒžö‹xØßd+¸éž"¹ïÇìV‡žY¯‹B¦b]£ÿØÃ™ ÇCØÀ‹®7)ÿïÿþïÿ4|³Â¾–§‘LoßöºÞé“XÈ˜‡=¿øc.“&fQšûDÒ'M0BkIŸ¬ƒ%]mVÆã=`|º´é¶q$9ŠÛ~5Ë‰:ˆ]m²µCZûäid<=¶¨ëÖ[°~H?CóÛ™ˆÎKµÐ;Ý‡lãÐ=Ú¥ò½,Žã‡ìéáKí4jš`Ÿ¡ß„ýÕTUßBÙÀâÍDÈ£pÊ6)¥Xáú©2R¾æ³úþp=ÞÑ«xX‰!x:\··•«ÑäWÏØP…ek¶«­CÍ¦á&4=8›†Ò‰ï
OÚ¿/™x~Ð©éßÏ¼oyÿ¦ÿ°lPìR­_&6ØËLÀ	EBïŒÏk¤¼{OÙóC¥8:Û¥×rÃã$úÉ¾Øg—ÜÐ<âžºãöTrª); fÊÝÏk&mz!Z@zw¬[/4ËÓ¡ÝE4ª){IÐû*¼!²š"3¯é^^6ñì¬5â4ÒÚl6QÌüÐôq»‰¹f'þÑ¥šé½õ-ö||æÜ×áÏlz©Ó—b9¢\qbkË4[€^Ù³–¹ZõûVLdqfµèE …[‹¯–J-uZœ´ŒU63öD¡ÒÛ,…¿(]HY˜ÒÚâ<À|R«çXŒ’J³]ŽnC`ŽRóR24;ËýâÔMêr Y€Ã+X%|A–³;iTÀª‘ÉaøøL"Þ|AÓÑNH~ò’ìÈ'/Á‡Ê=RºïQ_Ë ÛMè’d¯9îÈ‹ƒ‚ÓÉký¾R÷Ô±'Þt½$¾®©ýqrø€ºæ¦Ÿô0„¨˜`(—d÷iwð°uwüd`EÀ*/šˆYùh”& &T'‘DYÖFšîoŽƒš|‹Y5t'‰ðŸÇ×	Â¡Eœÿ ~LçxrTÒ:°Sš{],i¾÷"8ê–ÏFœY¶¾´UtËI?™Ó š(–b·XÚGµ?™Ü± `¤ÊûÌ0ô.éK{,GÜ«JåêãcKÀÿ×LG¯‘«©d™ªzo¯:¬ÿ˜à•sYl,6é´!Æˆ,ïÇjç(ËIëi¯:B¯Õî©£„ýné~·À[¨åbZÁ©üö‘__ÍA¨c˜c_¶ÄÐÆ—7vàŽ’B'‘ù€¥Nú¾=@ímVÖuHÎŒÁºA ßLmŒÐ¼Â5þ@ù³¹°Ñ«<ÞEú¤‹¿œ*RïÇØ´,a¨×'áÈE[9ÅæÁêä~	‘§í,ÑTsÅ$ŸÐŠ€(Œ‚[S”U±zUIÐrvyÉ³þú+›L}ý3Fããú¥ÙÕ¶<;JCàð‘áÌÍÙAƒ8,/dLL`ùt¤@J±k	¥ŽúµTžÄ;Q’=NñDúKÀŽ—:¹ñ¡u^_Ý%<{íuTîHœê<¦œ„³b÷×•}³Pj"»«äÑ YãðíE"½t°|@°fnÙF~ŒÚ‹ÊK7ƒý›?‘lš@Mˆ„Ùeûá›LçÂí	a{ ±Š‰Z8X"Õ®vþ‚>ˆÂSëºok€,¾g(Kní­dB€ôöL¢}©yœR~-Ú¨œ÷µ©ÞŒ~2§îÒ |œ¹Ûüßþ¤ßÏGá&ñ¹¬-Á“’÷õDäêTWÇã¯¿fôæèTÈ’‚}¶[wÇB/üIp&:4n4×Bb‘	ú„ul4=dr”;fþcZ‡[Þã³jTMNÏzÄ2ÅƒIB|gPRâGæ10Øö."çâsáÞ?Z£g§ðO'ºÍƒ·4q¥|ò7G«£Ô+]âëbThz`/yâKô(}ÐŸLÇsíÀÈ>9hºÊˆeA÷~œ¿-Îô³CñØØ ¬Äl VBõ8ðØVô.|õÐ@ÝŒÓ…KvtÁë
«‘xzÆF¼‘æÖj:Ì×Û´T“O¥=5§#0;L†êfú¥y›®ë/ÂÿáZøœü_QþÏ÷ÜòÝÈß-ÿçú¯ÿóÚö«ó>|òðÞ-ÿçMüÅù?ýäÁ½ûßÜòþîÿþÏk?ý§­ÿ‡ßâ­ÿûOž<¹=ÿoâ/ÁÿJÁœÇþñvù‹gip.FÓI@ë§©èMh‰H<zÂÁÒæ-˜ø¼ÈÚ»q*O²DSø{2¯œ -eÁ¹¸ù\ŽøÓ^RZýÜ ­¦0šä“ŸùÑXý]ªþ¹ý¯‚0ûÛŒ”Ÿe „'’^q6x•ÉzáÜj«a’ô“d„&â…mHE³òDsi–’6RxçOé¡›{Ê¯§Œ¢óGÄÉÓ¿Œè±!%†í¢ÿø©‰F	‰F[ŸJÚ²A<ÎÄ#¹÷hŠázˆ¡-%¼ˆ—@kˆEz_‚¹Ë¹œVy¯Ò«6crCþ0æ·ê£	 ¿•>Ü|Ú;d)ÊY€°ŒDÎÑ‰ÐŽ…ˆÏ)¢æ€ãT®ÈÒ ”O±ïË³…pãŽ€ƒãê*ÇÕÍ“RœjùR`$Ð¥ö ;ªJ!Ã›×–(r_íWöéŽÛ@X’-rÉ>lÅ@Üh‡fäÅÐDI*GÏ‰²,alî½±¥yfª-òvl1Eæ$r 8ª%–þûü<×ÄKŒƒA2kù±jb Œx«zº$ø¢e›#k	‹Š¦°ïêøæz¬cÌuiù±„hžs°9î¢è4:³:ìÌú4Ö°h‘Á
eºøúÓ0íL>Lõ-~
7 ºä±ãÛ¼ß,êâ4Ë>àIp"¤
¦“«œŒröúÊ#"ñ%Môaê«c Ûí7ƒ¯kHjb±¦Ùé¡ÎÑšumèÕÀØ‰BHF®[DtšFéyc]+§ï4Q\v@±Þ¬S%ªþt¢ÍMýûÃ¢è&soVÁÜð¹ÁÍnA{‹ÚÏÅ¦C¡ø˜ÐˆS®ßÎ‚¥ð¯WÀøMÎâ’¼Ø\zñJíJ‡	$Úâ	VÃsAaŒËd‹n”‰v6¹¥¬¡ŒGù_Ä&”1Ù¦ÛÕîUŒe$N“+Á[ZóBü¹Û‘GO$Ñ¥V»±Œ»&"·¾ÉðåÝ¢UœÔf×j‚K·'IÜ4s1~ñ­>	ŽQ««‘W‘ë­MÌxàûõI‡ZPßL#óŸšRš|,°å
Œi§Ó™‡CeG·7¼Ý¦ôSp¾>¦Eã‹4l¨xÐÄ(Ùéµ@ýH_;''úÉ1¾xù–œí“¼¯²çx´™#zÊ”_Ëb÷K&}–©LNûÌkŸ³£]jtf>+ÏªÕ¥UðÍæãžŒõ]±µch6ø…ŠtO‹ñ«l¾ÉT$7ûÔ(›½@YBÑ7¡§;¸îšHÙðvÆ>þ¤½4³ùf'ÍZré s&Bñç#¾™w¥àI&ÂÒ)|“žÜÄ6Éš9u»ÑMœQäð± €ž.Ä…wÓQoR —ÈFgÍg’17yer;Ã'¨(­sPK@ÂTMÆÞ*éî‰„0B"’„‘0AçêÄË¶£f/Ê‡#Qü˜#Hµ@ü‹üRÍœ˜ùÍ×íoËAõèo!¶î$¦TtD‘ÇUWKuÂÆêøy<‘á5œ³+N!Ô˜Âçwc[$ž*Sâ¦>O#øT–Æ&F>7×ÊÁ(nJŸN»xU¶E!J—Ý±LÛ1)JÑU5¢¶º|Oá½U·LÕÓÏºy,Ã’¡ÊQYÏòÚ.H šWƒð:ÜD{åßim±åü†Ô±-#†v¾S$ÿaw3ÔˆÉíNpÅO£Qê²Ž×Ê¯a…qþ©«n(Ó¦™ëË¶-Þ€ÆK2¶Ý3Ã°‚2^oºŽûƒ©µË/P§§(ðÇ<¨ÞäxâyTþì+|%ïn™lëW+ö¡÷cœl-Úÿ1W[„ñÊ7â0óñò¦ã25DUšs¤Á‹ÿOÓ¨+î›0H†•­FJò`q*G‰!MæE© \’Ù4Þ–Ço«“ýŠSŽêqÀœ1w3\›â©6MX‰ÓtTÈòÔ>Ïù”.ªÞÌì	R
^_’aâ©fhÓ¢p)5>ü©»Czÿ¦ÿxj¸*œ»ð*¶Ú2V¸2ëìÚò’œß_rK®‘m6ßkšêCöÃ¡y@Ümî%>#Ä¦—ëuQÈž¹Ví‰})Ò$M$±uéye]Ö $—ø`ÔîÙö¡µ0øÐ…È8é¼\çþíŠkü¥Ðl~Š Oª£Ë–d¹+¢ž'Íô‚¦ÃlR1q#F5a‰,6¥B²§ºÃbŸP{xTGÉp\¶›;›ÊI¶^BþºðFŽúK]§—%ìUŒ³ÆŠr’òâUåÅ³&Ê‹í&Ê‹¦»MŸ‡|>ƒ©8L¶‡Š=+OÏ:Œ!¿3¼.lxVû±öSu. ¨¦´ñOôí7{±i±J]8íAÍåÖ1Ñq. –¿/û“¾¾SZ´z©O|Ø³¬Ž‰àA†HJºlPïTg^
0-ý­Dþt’;tÿiUAý…} Q¹¿+òsù‰0š§˜R¶£s¸)ÛzÕà´Ï@Cz
8ozê{ï‰€šÑŽ¶£M°moØÎÏsí Öqö¦·Jw•XUlÞÕÝ‹|<‚§# <·•rRWø®8Zfôz¿òüe`a
ÕãÓòØ–4†W¬¾bqPå¢iLæÆ˜Ñ`…Ì–TSutòrÔÑ/¯P°ìNê³–cós|Q5<®ÆÕø«ìy­]qÐu)½-ÐQÇÿœ^"ž<}³œþÅ˜è·Œ=,ã:aŸŒ¶¬ÄptZ°OJýî–ÇV8È1¨+rãì,[>iöI\‰vôÑ¢Ûñš#b`ãýæ¤yu‚\ŸPŠlöýÄ=Mz½E¶„Ds@ÔMb	jxÄVRëç.Ìm$«óYÖ°«’%ÈÔÄ©‰!Ý:ö¥gŒõËJ¹žðS«©¡I¿ž@8<ÒxÓéNè–µ«V²,Ì&B]Ëá½œåÝsØVøHôËn·W¼Ë"‘ _È‚±¶äbÄtGÀGÍÜÑBÓ›%Q÷óžËÌ© fš("R/1HJ	ço‹}¦[³Áþ™ªÔ²_Žõ%1
ß.{ãŠ¹l¸{¸7„œ®ƒèùxR¢ä0Ä££Å†8¸?þÀÀ­ÜæŽo®˜˜Ç¼(–¹{Yx,„ä©6–œbÈX	O¦gu76ÆÏƒ ³‹<?ózQê=Û‡€÷H©4²ûÇš^×Äútƒk•xu0€-R%ÃŽ‘Š?üúëÒåe?oÿE™…ï• ì†bÌÿÁÜShø2·@ù·ÅEÇû9Æe F÷DÆöLJ¼2N"àŸoI"Ø„//5‘màÞ³N(ä@bõ;»¤Ððün¤Y{jÂkB¤FÌïñˆþZØ0üqsX¸¼»4‰…%œ¼õ…í–}*H7L§{aDÄ‹‰ùS2ßBÖŸ’‰8¨ZR|ú´>VâÿùDÆJêFw3öØJ0tIøð_=ó 1Ó÷™¨o˜è5³ùšÿCã<Þdä%ØôÄÄ™âÅÚf6Ë&JÂ‹$xtrÏž{óÓ›v=J¸‡žey8D¢fRØ'ë({„[äÌæ¹@÷š®Â%CÔ7÷þÇ_µa<°b›=	Í­]P[J‚pš«ÿÈ¾^º*?¬	;ËÕø¨n8©ƒq/<‘’K³>ôãJ§8±ÎØËLÔwK?ïê‘×ÜÏ á¾#µšº^O0	 “’:o-@9ª]ePÁé ‰8yXü+“Ñ”¦`ó Tt¿þ‹áÿ¤¦ÅÔ?xuüÿÃ{_Ýâÿnæïÿÿ‡þkÀÿ_Û>puüÿ£Ç÷¾ºÅÿßÄ_ÿÿøþã‡ß<¼ÅÿÿîÿüÿµŸþSñÿ÷>ô×ÿƒÇnùnä/ÿOHÁœ%`üâÂ†Ä|ØSë\œ ~Iù1!ÝS)Õ!¥ÈYÇ¥¯ð:æQêû¤mï,JîFbéÜD=3%/Ùæz¶ /ê ®ëA2nÁ…äÈ#W/ÇàFsÎ¯–3od?†!€}Á‚+ÀRèì#Rc€ñÓÞd$¢£QYœ8 Í·œ÷:è¡Ä}­©~£ê€C0K —xuçWW#A®ÎRIÎûfîhÁ³®þtIÆ&ÔÄ2€Ç&x ºõq>TR æn¾Ü`¼Àf:›@ä²£â,?/«Ñb¶ßþq=Ûyq°ûâ@]ð«á…µ]zri`öøáßj¸$ÖKÙ	^/ïÌÉñö=ôhÄE˜Gz{ñðÞ|Lj™µ5V—ioØ´GemSÑØÝ[Ó ±%dgÁ­,‹yƒ6LÓã'£Y~Üà¥¼¥#\íç¹e»†46àvÌ~ÔÙ
I4`îˆYDö}+¿ÈêÉé)x§3TžyI„¥'²‚²üÛ˜Q'E0¤Fdò¾¥ßFR¥í£-ýr“¯Ø`L]ì°dbK=ç‘¤WºÉWV_nÅöÍ÷c4ùšÇxm6€±j[‰­Y|WÕã¶}AË©}˜«û4aöG÷šÄÚŸÄxÄÖ˜Ïnl6Ùï	i›‰pýf»JZ(Äc’°uGDdš¥„½Zx ,_F¤o°„žfYí;À&?xÛ™¨´%ƒ8[2(²»|t²ÆDÓeÆÍûq"Sj€„ÄØÏžï~°ìã’eY{¯Õ¤¢ñÕTN†Ÿ€qÌï¼lïïZ]ñ f÷ï©q3tY"îýX¦œ:ž~W?õ\&y`Í#O=8þÜ½Ú`2ä•Xæœ¨;ª‚ŽÞâë=›'.‹=WjKã¬sÀñâËcÞ¦eÃoe¸ àÌ×®ëp^@”ëñƒá‡sãQ€ës{Zª¾õzÄh?—`¯cÛŸÇo{%)¡á!¬J%6c¯C1üIÝD(0A¦n“˜œµà±qpA5ãpžÊjRû‚£òtNz¹š®.û®CiV€ŽbÎÿîú\Ô&ÊÑ‚j£’ôkLÉyîèn°Qú­ý½7×ºi]6†É)›¹ˆÒëÃðœìÄÓ{\˜>»=w]4.Ý¨MK<îmñö&€Ï¿Ù`ø^\”þ†![59¼­d[ÝpYÁ&9cÿ9–Ñk3ŽúÚŒå´Qn3‚<Bo"Ø¼+°ÊƒCˆ;y'Ò‚A/dÅøxñn´A)¢ýù­b<ªŒÿÒhAi¨åpÿáeVîì£>ª¨–Å«Ní„~=ËÕVg6‰`aPR<]ˆŒm6r`å/%uûPt|?7.|;¨ødíeˆq’6u9ûÛ°‚Ýt &þ-ý¬—WJ3e®,Ãô$ï-gk£üTçl©œÙÊúk¤Pc+Øý9¬ÈjC^ò%p—~äÂh×¾y6ã®}Øt´V6™uaH‘³ªQRo1¤i¦‡ª s«Fµ¢ÏlšbX§f×¨^”ƒã‹ãžØKö·ŒmjèWÕ@ÞUSX÷³þ×gÿ®ÚÀ³ú¼
öÅŒk¼Þ°Œ}*8›Éã›0`Ù¼±P_Yq€‰ei"p+‘¯á=þŽ’™“ñÜ@&þê3æ%_½q´ ÛÑØCIb}5(9‹ñïö¶ <PÙá‡7Èw9¸#bÎèMÐÍíÎîÁæÎvûÙ²AT0ˆœZÉÐx17lÐLz1s<v–$•NÕ€•ò£š¨“‹LNT
þ÷B«\µ.59¸¾U#AÆ,ä#®‡¦ÂÞ“¾,OÜèÂ)<0ÆcŸqSKl­8­¡Dp=ØF°ÀbÐõ`áFäcVÀFÕƒ‡™‰tIF€F™Û€–?Sº–®4K©uCâ­|ôÖjØê77 ;Ù;ØÞ­ØÄ'î—<¾Â&Ã_jWŸ·YsD—cÃ*3ý¼Ý0Ï¿ä(Îº›­pÝÅlïcOÜÚe¹òž‰mÀ÷nm5¦<.(å{¸f‚[¶Ñ™³®«ãq·îY‘ŸƒõÀêß¨¨•lpájcîÇdˆ/iÐÌpkAX«E†!vò‹Úì9w¯¶ÀMø8»#ÿ’wNÔuóÈ‘>\YLØvë
íj£Ÿ°çêìå=äAÝ?œ @ÆŒ2ê!âçjãÞÐÖcC,­ŸÞxïÑ%ÇÕ3¤/þÖ¯Ì]Y@[ £Œ‘«ˆÃŸ4¥à”ƒIÑå‚i’0¹¥ãW¨Å;H ül^© lØ?Ÿ·ïbÛA A}Éd=ô–å. ìü&ëÚXhEÞa·j:¦fi\ö°BSh¦áhS63ÔÆ%é4ŽÀbYÕÛK˜-í÷–¾'Äm"6QÇÃ~\uË2—{¶Åš;ÿ ÞŸäNá.LªZ°èkT+äZPz_^Ÿ™"|ƒCxUâ­Œ@ùÜà÷ã·^»4†ëg*Ã{÷´»Ó—ÕÀªklÁ¬íþ\AÂ–H-^,IÐÇÍWûdL—d½0œw0×¼Œ-H¤|—;`
ÜXFÁoöfoMX/?LRæhêC¥%HÍh-‚K•¨
‡>r‡Ä,âXÈù§Vl áòµ`\Jõ)YtÿDY·"úàŽíP&””þÃ1Nø<‚úUs‡h¡bjü—bÁâJw{ù…à‹Kki2q0<ÄØ5Öä4á»F;÷”9y•®C¥ÇM3C}Àâ0K5,e‚–º°·òrdOÕptö
„µ £Ét	WrM¥i	_>™;Bˆ€sÆ°æf>ô‡tùó¬Ù³C¶fS’}À½©²ƒÇeÓ¤ë6½B&ß}º‡Hqƒ™Ëiˆ!lNkø_Îü' —ÅPF\
}²¤ÃYhî ÿÃÐoò4–ôÄ@~G¨ýï‡Õ2™Æ¹	›lU.›¡› #EDöÃ¥g÷eÍû“Hì5[ƒ=*
lÞÖaÔ„ŠËÃ¥æµËm4øaûXGíi®Í±sX÷­½H¨OÄ¥Ýµñ®ŒiXÇw]ÇŸæ{ßÊþbo˜o¼œÐù½C¹–¢Ž6×loÛo˜¡–p›‚&Ž¸tj©®•5sß5óÀÖöKNÍSuÈóÜ#šÀf¾¸D6³ý³ÂmW‹'p<ùRÂˆ ^Fúl.™½b¼ñ2b#è7Í2q@ÿ~á
ßñ~„Œ¯.÷|Åh0¬]¯\Ö×‡¾ž¸ìKá+*ó§Ëu8ø…†ÂŠ}-ü‰þý“«¦ÝFY5‚'
xã¥‡ŠVV£!sF»­7ä•9¾ï.ÂO÷wH2¿}äyÀò8—)ÏYl¢i=Rê—a56¯FÞ¥ÃZ6tž^‹’_ñÖdsñš‚7WåÓD	++M$[³0D?î4}Ükú¸ÒDO²Úôq½éãFÓÇ§ôqåñê}ï£¥DÙ¸·þøëUïãAÓÇ×!™Šû¨ä9ÈêS­œŠÇ9°ŠžqR3|âŠõòÔ )CuøôÐfÀÐ€ò›ÒnZŽx=g…y³y ”ËñzŒ…½Çñ‰áà0^;µ1›·úå]¼U«­½s²«‹ˆOµ¬k)°M«‰Ž{.à7çŒ¶¹ƒÁ‘g<#=H†Ú—îQ´ê³ýÍ.`äÄ÷¡À»±/ŠýÂeNqðˆx.jFj €»Ö‚Ú…Áé:"zî„^C…úeZEºV“Ïžiµ÷ý2ZÍ,,›ïyé	=Œ÷dhQÝ…â1"é°fš±Á‘ÞmŒ# >¾žÎSÒ'*6 N§¾“ö¥šÚ(Oƒ7m2
Pí®plžu[ì7h
Ê7Ý÷:Y±X´AµÀsåÎ®[ràŒ6ç[Ý[6§ZÖÑ½­¬ñKcïÈZ !v6÷¬°r!.t˜âÌBãf7AÈ¢C­°¥«.“T\ËŸÍIÁÌ˜Ž®MÜ_,snoÅðeÇÖí"•/f[rRà³;wQ ðãÂÌ*æÅßM|îÏýÁÿºy-Ã"òâß¿‹ÿ¹‘¿[üïú¯ÿ{mûÀGÅÿ~r‹ÿ½‰¿8þ÷«¯î=|øÍý[üïïþ/Àÿ^ûé?=þ÷½G~üïêçÛóÿ&þøßP
æ,ô×±‚~ÍÜKáíoÝ[ž›õëbSPc[´³9è/Ú ‚2ÁÍeƒÑ~. «º÷"s:ÐÂëGœÅì»žë°*nFÕœ¶ùIÁí=Ðë†gŽzÝPE±¼6Äiv+ïv]Ô÷yTh– ûHé¾ˆzß˜{A‹?«¦‚Û‡z7cã^^×‰°àLž2:Ç½½³`Û<0xC ïHN¤Þ­ªÉ¯‚øj3ë)RA	Ÿ]ä[–—Âùÿ™=ÊÎªÉ¨¾‹î6àœ
¸6„hï4tªæ¥öÙÛœñ:¿õÐ>¼ÌP0º# ³6„»•ÿ\b}ŸïOzãrhüLä·£-ƒÕ(»‚Â÷·¶ª
Lü€ËÑFgâ‘6÷pæë[¥\»È”ïÔ?lï­Ôâ
Ë³>öƒ£­$èŸäL9¹R~K8!†0É@ÜìÅ›dŽ%hé ™wLJQH˜—‚áßæÎçœo5ìB»Ç"%ä„%—pCS¯ç^“™áë¥á÷Lú—í‹9ú¾HOõÅ;®{}æ–f¦æzúÇüç#Ý³ {áj2	kÂöÌ¬x—´OØ#¤N¸)I–\½–ÕnÐw{DšÆZ+Ö‹D€úÖ9jßQ¡þwÑOK¤á%¸RTÑèy3ÇgÄ& ò†–W÷¯JŒÐž¥v[ÉT;ñ„iò±	–nÓ›ÐZÆ5×!XVó<O2idó!+â†³F&¢{ð:u“f-xWvOaÍ”Î’,‡‰°rÁ¢‚w‹#•Ix(UÈƒ±½˜ÄÖAÌXˆ÷‚ÊÙÎÇ’>4q:8—ï™MÄÔ" /ÀOXôQ¾±“AÜÍ. ç=FnQu ABàD?Ô˜}•z7fe\EDb%sˆ­wÜÌyÏê.å‰ì’};0™‚Å‹[ =Ïª×l„©é‘Ø˜äºaõG†6gVÿÒ6†/pp»V­NT8Œ‡©3É+ÃÖ­GÕ¢XæÇos ÏVHÒÐb—g+æ¥^ìLsž1£ÆŒDob8öß–C|PçñuR5ÌD°ÐÌÉÁä,*ëfL;B8}¶„èJÝÙ~öZÃùÙ*ªÝ}n
kF]Ì#¡ÀŠ\OåÔpr¢£n†oiìèYñ=q:¾ 5°wYuÞáë¸Ræ´š8@dîU¿Ñ+5Cò[DÜ“fË|$4*ÚŠw˜ºÏ†¦wHÑP½Itl½éïMAìoñÑ|4mZ1œ¦5ï\!ÝQ÷: ¤ú¢¦mÂ&Ø4¿×5á¦!.³§±Ðél6ÓÇ\ãt÷îzEÑQdrÐ9WÚäÊÖÿŒc íü</{ùQ/’áµ7ì”øˆÅÖ÷s`²í¬5€²§JN"Á`ÙÜ¸òéèl1+á….Ë&!™’í£æ¾D{–U?À71Ÿ™š,Â­1C@0Ü3b°×5Øý1 Ü;8)„G”°²^;X;>7‰Õw¥üm¡³“ÛœVjNÇS­ÅPÛç°¥ÉÖ¿ ÚÐÊ±¨È³a¶o„m'­…=Ã¼þ¦Ø¤Ï_öšŽ¬+ƒ¯ùV9}í)+×	¿¥^?_ú{Ý‰š½\ùntØk-y)ðµÏ×rEðuÔ|pÕ}éGÈ1 ³½ûÒš§]n	îv	MéÊ‚áÑ=qíàÝP”’K¸“X´õ”›×››áÓö|ž?-
¾ 5Ùr§#¨EÒðjefÏæFá¸ô3+yp²ŽzØ4·ž5±h_5Ííà‰š–AØ¦ŸŸêLOÂíÂ¬
uÕa²•A³ùÒ€õÂ¦üÚÙnú¥°Í¶ÎÑ$€57xçKæ’’í—ÿà˜@·7#¸Ïøà…íƒC<k¿iz8P]<ƒîë]ýƒ?'J€Uæ ýX›?DÐ±'¼HÄnÂÞ^»xPQ&8ÿ6Óu›ãÏ¡ï°«ææ©È^;89œh!ØÚ–+@×Ûx°LY_žÄ[OÃZÿpI ³ÍMë mN:ˆä"ˆa­~:‰§Ö€ï­Ë¸1’5jË5jûPiÌ2á/Ô¾sv¤e”ÍÑÛBýòðÕÙóK-HÀßÅÚý\¯>c9r0 cV"yýDÉ¬‚Ù¾„Y("¾´}`Ñå¶L4LøÀm†r>pþâÐ—§†â€FÿÇF¨¹Éî2¾ÐÈî°õÈÎ^6AÎ_º–¾Š@Îã>)o¼ìÐæ×wî¹zøðíì'Zâ›¾”Jàu8`8§öx’ë@Ø¯ÝÁ¡AÖ¯è‡×®‚]ïGÈÙ^¹4
"qù°ÖµWXóV#øs}¼¾ñ3`ÉkJ€âèó¶fÑh³ónU´ŽëÐö:@79°¦C›˜oºÞÏÛ>ˆº½Ñ¢†cÊ÷Mß×ÌÇ¯Ÿ¬®¯¯ø™›>>mÂ<o6}|ÖˆnÄvï6}ü±éã‹&(õ«¦íÕF õúµ ­Sž~Öô¤”ØjÔU·vÐå­·³Ü¹w^¼¤Š› ¸`ºÇáØS hõ!fãb:›xH”&$¯º-«C ä¬_ôôCŒñ½Ù{ŽMB§íBzÒµÂ]%bn16\!0¢2¿™€0Åu½¼,O¬c"
¿þºÌ#›SŸ4fs(•¢» ¹TC­­×:ô‰›_sCÈ¡UT¡ýÒXß±mó ÎGýÐW<]°˜«äZÜ¯?#Â{{ZDúÕ¸cœn~J…uÚ°Î——ÆÇIøZA„y€r—¥!Šðç‹¦†¾ÖQ¿Íïø2À»êø¬Pÿk{æ¹r€~Ì¶$ãÔãÿÄ±øäå†šaó‰<@ûÉŸ£ìGžZ3š¢›‰‡]¼(ê¥A%WúÍ[,ð„+UNßÏgb÷“emÙÔ)‹‡ê–³íjJ;õ´è5Ã‘Ää6ŽÄ÷SÐóvúÔgÆñkÊjì¹§F½UÃ!›a$¬|U8lé¶#´W¥n’­‰¸ÊHµO¯µ8³ò\	^¶lÞ¬³@`á ]>>#ù—p›^žWÀ6Ac"¢ƒÍsKm›ÑÑ[A¼´†{4‘¸%Ç]u=Š/SºýûLÍøÿ/ÿûþ½Ç·ø¿ù»Åÿÿ¡ÿfÃÿæøß÷ñ¿Ý¿ÅÿßÄßƒ¯£øÿoî?y|‹þÿü5áÿo(þ÷Ã'¿òñÿOî}u{þßÄßtü4þ7#HÅÿ¾.&€©‘À¯™À.ù‰œ ³ù¡»ì "MH >ÇxD‚[²€[² ó7, X·Œ7Î 	Fw´±x¿î õúÚü%9Ç'èæX’e•€Èt}|u!3A¸³öîæõ1	Pœøß$™€Ë¸
>y™à*£¯~~âi?+û€’k¢ H“ß0¤ßAjoŒ‘@4àKÓ¬ÒÎqufoº_ZŠ&5lËÿÊÌéÕ3½AzøWá8ðÅˆ$ùu²ìM¿;Q÷òß"ÍTÇo¹n¹n¹fä:›W20µµS]•õ@Ó¨Dê&þƒà‚zƒ$òÀºn&„HÏ®J‡À‹ø¢œb:ˆf“°¦T_Œ"!œ®ðºz½ñëd	3nW‹ž˜à›Žj(ïÉ÷ˆi,
°§°«Ã»³bDÏ%j9Sö/@¸Ð0µÑ¥}u)˜!ÇÍó/4ï«_„„aEGç­ËDCôþö8Äì65Ì*¿i¶y-¹Êy¢^™·!Øµ§“7Ä4­›dpõßÒ8|4ƒÇß:—Cph&tšÃŒ¬a×Bí åÓùÂôŸ‹ä!~|]‰éAŽÙéROÿzœ¢'!ñ?”…­:rB_I¬6Ò”ñ>dóðþ@šæÝpˆ¾¥„Âß¯Ähð	”2ó'°I$Ÿr§RJˆœ³óJˆl×M.!
ÿ2LHEéG3*Š7Á5!%ë	'DÁŸÆ:Ñ42³ROð2n„¢ÁÃ©„"æ8a¢É>ŠŽB6ïÅI!º>1…ÈqËNqËN‘%Ø)]Kg¢¨hp7™‘§"ù–;;Y…|
ÿDÆŠØ»:åú„À›;jyô~aMI¾q³šJz‘ôÆúâÌMŽ±¢æ©ôáÅø†80¤gNFômÓgÃH*ò3SbÄ4ajEõ_œÃ-„I­>#1 *ð·Ž6*³ôìŽÌkÐ^’øù÷Ë¼1Ãùiôéªäà˜¡ÅW âˆ;ŒÅÙ8Ò]ù‚”ñ«Þ¿(/Gt»6rŽDéWcèˆ[.CšŽäëÈˆquÄ·÷ÂŽÈÈ-kÇíßíßíßçøûÿ“€dì Š                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        