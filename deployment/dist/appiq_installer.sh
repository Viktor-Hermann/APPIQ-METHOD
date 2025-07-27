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
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 APPIQ METHOD INSTALLER                     ║"
    echo "║                                                                  ║"
    echo "║              Mobile Development Workflow Setup                   ║"
    echo "║                        Version 1.0.0                            ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
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
        echo "📊 APPIQ Project Status"
        echo "Project: $(basename "$(pwd)")"
        if [ -f "docs/main_prd.md" ]; then
            echo "✅ PRD: docs/main_prd.md exists"
        else
            echo "❌ PRD: docs/main_prd.md missing"
        fi
        ;;
    "validate")
        echo "🔍 Validating APPIQ setup..."
        errors=0
        
        if [ ! -f "docs/main_prd.md" ]; then
            echo "❌ Missing: docs/main_prd.md"
            ((errors++))
        else
            echo "✅ Found: docs/main_prd.md"
        fi
        
        if [ ! -d ".appiq" ]; then
            echo "❌ Missing: .appiq directory"
            ((errors++))
        else
            echo "✅ Found: .appiq directory"
        fi
        
        if [ $errors -eq 0 ]; then
            echo "✅ All validations passed!"
        else
            echo "❌ Found $errors issues"
        fi
        ;;
    *)
        echo "🚀 APPIQ Method Helper"
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

## 🚀 APPIQ Method - Mobile Development

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
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    ✅ INSTALLATION COMPLETE!                     ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🎉 APPIQ Method successfully installed!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next Steps:${NC}"
    echo "1. Edit: ${BLUE}docs/main_prd.md${NC} (customize for your project)"
    echo "2. Open your IDE (Claude, Cursor, Windsurf)"
    echo "3. Use command: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}💡 IDE Support:${NC}"
    echo "• Claude Code: ${GREEN}/appiq${NC}"
    echo "• Cursor: ${GREEN}/appiq${NC} or ${GREEN}Ctrl+Alt+A${NC}"
    echo "• Windsurf: ${GREEN}/appiq${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Helper Commands:${NC}"
    echo "• ${BLUE}./.appiq/scripts/appiq status${NC}"
    echo "• ${BLUE}./.appiq/scripts/appiq validate${NC}"
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
� �]�h �_oI�/6������sn�Ψ��*�Կnv�g)�RsZ�8$���A�:Y���QUeMf)�Z����a?�cq�����_�Q��_}�Eĉ��"�����f�;�bfDdĉ'N�8�wz��4�-�_��߭[��߽����om����o'wo�ٸs������[��l��Er�}v����"-�+g�|^u�ES9(6�h���������/��������O���D~����o��G����_�����C�'��_��uP�߸��nPL{@�I֛��Y6Kg��������]��-�����y�k������aV��?9p��߸���w��"y�>:�~�����d�ȧك��wo߃���I��'�|���Oo���O��=�>��r��n�u�X���r}��۽����W������;�;�&GP���VURk��/M���W��{��e��K��oޅ����J~?��/���O��|�u���t�#�q�Νw��࿷������~�?Y�N|r���_�����ܸ��>�/��ݺ�	{�'���O�'��=������{5��.��z���n��*�I���$e1\�~:�([󬬊Y��e��(���jP��E^̶�/��$�}U	sV2��S.�T�l����O��4�g���r����l�f)�|�.�,A��Rl��A�;e�.�*�2/�q6�����*Y���(�a2�~�w�z2�βI1��w�Ԁ��;��(;�RoF� �/�?.�2��U'YVЧG�g ��y����쨬�Q^V�J���`��l�����U��l5�ڂ����$I״0/����]�Ӊ�1E��J�PwF�0=Z-ˌ��Y��+ۉ��;,���45�0u��*�\)K@�)�(�%��"5�8����W�OMN�t	33�g�|b0��&y���kڵ�h�b9��jQ�!�l%�C�m��q����dOFӇ��c���'������FV[K�e�4�dr��{�u5"��߿`�Z�U+`0Y�/��o���7�����]�77o5���P�P�t���Ų�eqj>Z�LSyGVB�(��1����4�p:=6O^|c��4q0Ig4�a>e%t.1�e������\:��|��&��@X�v�K�����Y䣋�*M�۸}͢�~�p��B۳aY�C�H���䨏�育�Z��zߠ�\<��4$���J~�g���c���U���iZ��6�;"\$�h�_OF�M*H���]R]@Ce1��DT������=�BB�
���r����|�t�%;A���nH,����5S���y t����Qg����4)�@�j�/���Z:�)RR~9�����I��se�����3X���|萖]7���8�̿C2���$�ӫ�`��@+�q�]��uAzHq���E,V���zh�c�@�b��t�VƢ�;�,S��d������I�["�/9�cS{������i���d��wc�\ 5
�p�'�ῃM}�$F��� R�DΥn5P6IK�t�؁re�:Љ�޲�����?vD
����u��p�/�Z��7_���u�ƁH�-Xa�����J��H�OXhwOhI�ҳ�������]�Y�n$X��q�����	8f����`R����=��n���tG��!l�/��"+�q������'��`0�L)
�/�����I����]+��av`�& V5�E�&�A"ԁr�;��b�}�]��E���'D�Yջ��d+7C�K��p��de�����u�}�=�_\NI����&[��$����.�1<��"V��! �ɿ��wt^~��۸Ca����K�����ܼ��vsQ�~�<��i9�5O�H�L2)NA(��ˇy1�%�[�5D/5��Y�/�syۃA���d)#�p�c���̱į��ܢ�V�Bz{��Ԗc�^E����l� �_a��|^�����c��8É5������}�+KG�6����i�2j��������#�C�����l��8�TT
@��p�V��m���k���R�o�L�e�l�����6Z�@�]��|������|��%���������L�	fBa��i��p�-��������t���������laH�=<��ͪ��(;�A@(Y(��I� M�5���1�O��#����{r�Z	6�o��8���ez�abE���0��W��/JaF�;�����0��6<�(�B�RXϧ��%��b=]��71�#-�qJ'�A:O�8�)J�E.�����z����OQ$mHt�Y�6���y�$ԘZ�}�]Kf��#=����V��������"���ٖ��߃6�J�Z<M����:]����%jc�f'A��V�}�2��l8x:���)�g)M;c�d�?�9Dz���5M�W��q�gY�6-�Yl�k��;nFG@d����ī9��E�G�bV;��CO�ϡr@�ۓlb6!�P�
�E�����NYTUר|��jA{�,ˆq�^�';>��G�+|����T��qc���[�IY�J>߄�	����A6���Q�ܾukZ/�U(�q�����8�_jj����`�����A#�
v?��� wPV.�&�1l��D�&m��-��p4�L�����J탽d���kmn�M��,pe���>���`���Q ԙciIy�*Ժ��bX�AI�e��L]�j�e	3R"`}R,"����=�0�h�(�lr
k<����5���,�il�[��2�-�~��F���'5�cc(IY����A�.��x �0���o�f��m�LiWd��9��ɤ8!5
���ft,:�6Xp�V� K��)҆�5��P�cB�#�Jj��#LD{=�`�Ů!�"D�������;	��i���j��@t�	ќ3%<�3t��x��.���׬�^�Xl�p�zS�Q��=���I8<�敁f��;ZNQ!`�D�˼"��Jv&�A*C�|Y΋���,�,����rڻy�8-qe��Ra�1���ְ�
��t�D�<Z�&��9�}���=1oe)�eN�j�>0'�(UQB�)<�<lod��<2&vO��r��R�hp���/<7����:}���q:�N��.��;�n��Ӫ�8��)W�8�6��Y��E'!���#i�4�LNpS���xP�v�����4��r8��;�"�p� ;FT`e���=dԬ�x�\��i�41���5����=Q�-����+�p��"��B�=)��P^լ��
%�mZ]�8��Чu�5{�2[��ɳbֽ�U�L��ǚ�|c����~ ��K%��p;ѨL��k�C��fb�
9`�#eL0D�ʋ�V^��{���aQ�I���N���wp09K�DK���a'��9�^���U�p�K��"ħ^��	[�c���Ղ�؝�q�ƓU=�-x,,P���;߹Y�b�Zc��8�Gd�k��a��\��s�D�Ga.T��J@�O�-��Z<� 9�]0����]�ߨ���K�$���ˡ���N�����^�O�:Q�^ϭ6H�{���Gƙ/��v�~�Ӷ;�O6o��$يJwu���]lI��$��?��`G�3��R��y��lOj��GNu�^S?C�|��A � �|��6��>z�!�财_ٌ/�ܞ�]�Z-��dp>����	�����n��(9�]�~�E2&�_�[NS��~��('��ZhW���4��
�>^QXi| �^9�o:���R��E;Y��d.qc����q���i��IAuep�ʆ�ם$[zk�z���r즇���:�*(l��k+9�=:^R���o�� j#89C4������n�㇘�.�p�]��Y�y��)��H4�֋Y���ɥ��4_��n��E�i�@澧C+�Hm��ěF즭Z8�f�B�D����d��l��y����i�}V���6g}9!��i��Ew-�IzRHH��jx�9X�f|	��Q�\L<�,_������t�r��s�Y�uQW��k�G@q3s�t���m�h�e��[jm��B6$i�Хd6(`e�Ʀ�:a�1�9I�����f!��*�{�r3~ڛ��V:��x��VsFƚ,������F[�+�����2��-��M����H�������,�d$C�X�J�D�Y��c}'5���xK�h��~1�y�	�B��.'�LF����p4�^�AR����uޜβ�-H]�?Rg��
�M,|p5���!h��/���21Q�1n�s$d�#0ճ�3p���h���9�Xb];�R�����D<Z�Ls�4�#7Nn�tΟ�~g�sV}>;-��/�2��J&�"�h��J�ދ����}�:*��}�D#�1N_�0��.<wV	��dvb-p(;p��(��`��pY���0��xL[���X��/���C-~�iA쩗�[��E&��[��#�]X���]T�)�J���-�4��1�OW'f,�}�I_��%O38meɫYqξ-V&68���wc2��u}��p��y��|]|9�W����׿����YY�#�{����ͻ����w����5����r����6oݿ{�:��C����?�t���u��O����������?���������������!�o[E5���Y����^9�I'���j��V�	-p�R>`�*S����+��@�w���M�}+yQ~�%/�s�2C0���u��������^�� ?;��g#�$Ҧy��$�`mk��\߫����Ơg"�t@�uB:2a�M]�.z 7�uqV��²l,����yl+n<|�Z�h��3tQ͌�׈�R�邖�l(K'Y����\���ʴ���l��&��X�Y��Q��x<��t(/��R��ɰ�E�$�qQL^ac��[sj���왆���`�,�tka�����̠|ݪ����u0�R?~�,)F�Q1�	�̽(��$���!Y���%m=��:�_j��[��k�АVg23	�eIA��b�!_�@R�b�SR�h���_μnRH�47&|��l6FU�}$�0� �.rX����va,�RSY���3��|F@��=OWR;���y˰��QZ:x�5�b� �!��Gg͝�����͆JZ�'�rq�Mz���u���L{��q6�����b�T�Ag̩Mã�o�[�$E�*y.�[��? r�,	~%�����)z�����rJ�+�ž�m��/�f]c��S%��t�������ߑxx��,�������O.`U�+
�#�@���E+l�`OUq�|���i�� ���7�T��(YZ���8�����|�!u�]0l�
ҜݽR� }Z����ϛ�Cx��&nT�mnl������Q��߀`9"�UTռ��
��-����ǝڱ��?�uv�s�u����2����>��Z6М��r؝�/4��n��:�hr��PEYOÃ��簻vA9�y)w�|Q"��+hD��0�p�.�Qg�r����K�w}��'W&�.l������3���O�Q��v��#�W�q�e����.��y	|���m�M	�4��@t��9l��[���V�VB�Z^�'��l�(��C�M��#��������� X�1QwH��j{�p��a��P~�����\L�Z���>��g�*��,V�N�]6*�U:|��󡾈]�ߧ�y��Y��w�_������ٷZ�ƣ�E=S���}ݹ�(�`9�s{�����t&Ԝ��W��/��X�v���1H���
t��t����Q�|��FӚ��1;�4��I��{C�����83]Xyl������_��p�a�L�g��.R����ˬ��S����c�X�gaU�I���&r�D$��N���<#&�u\��e�p04RuY�G�F��ͽE�;�p�O����u�gE�-<#��{Kx�:b�V�!�;�'a �*�� ��'MV7�<��qqP��z����͐��]X�A5�D:��h��uQO�oju�_m=�ܮ���"P������� 
8ݑwK��"�T��^,ďHv�z8��ֽj&Xˏkq�2>&M]l>G�Կ&�36��6�v�����3.δX ��D�p��_������Ώ#�������x]�/O.jqD�xT^5D<�.rG]� �a^�����Xi�C&T�wa<���8�0���	p�䳛�1j!QM�̡��L$0�ӅM'�����X!��n�0�p�zC�m��1T�_����p>vQp/�T!US�Mj�M���|q�����>'Js(NPX��5�b�����A��ULr�������^�aDI�U3M��s��\�T-�%8��
�
u�<�3LeZ~�j����k���M|�~,:?O��(�Uvʏ���s��L�-ԾQ�\����rt�0X+w��}�ϖ��{cms�[z�Yv���[Du�`߀�\�<F:+f]����� ݮ�lM�k�q����-Z��L�)�l6����Z�x����PhOI܇T �M�#�A�(�[��a�~�5V/��w�]��&r�A���Y<��rؗ[�~�h�^e�&[���mUW�� �<?��:��/�(q���FP��5�e���M����n�:&��k�ߍf{Ų��e�m�J�i7�׌��hD� ٌV#1���|k�����7��^T��p2H�P�[�9���2�������{�h��r����l�����GRcGr��
�e͟��Q:�a7�ye�N���^�Ȁ(�"u��x���m���ɤ8��C���XIAV���b���6-yt�;;�K���[P�E�������P�dr�3]Ny��&���Q	[&v��E�72��٬� ��|Q����ɫ���.��p�������6����Ҡ��44���,��y�4�'d|1A2�h#�f��i��+��}�n�ˇdK��~� ��`�3���OU2j"��dX��8%t�&��3�9!L���2���D�<	.�� �-�'�$c�Gh'�+/҉"��I����ec��lf��8PD���p_*��)^��;�Bay��C�
�����fWH��������ġ;=7��~J���<��n�����c��-����r�Y�|a��K}4WY�C�\����||�M�K<�C��?��:�ܻu���A~���?�_����)~H��[����?�/�����w�������'����������s���{��/����W����6(�p�ʚs��l������L��pGp{����O��+�td�2�|`B���Җ��A�!�n�
�6���8~
���d.T /��ݿ�$�+��%uQ#o,㑡��9=�ޟ[���9�{����@�q���3��˦\ۀ��d"�W���`;�r�˫s�ni/Ÿ��vOm'L���(����}$R&n���«��g8�e�8HW�NC=���b����!��y�c�:yHf��Xf�f���p�vJ�tW'
��ܧ«�DG�c�GZZ�;�!�K�:N�ȇ-hų�� 	��s�Q�X�b�D���L�8�<���'�p|�1���K�.��8��B�\Kz�^0�&!��{�SL�ip�bS�UvA �������r̀\
���f�<֣���L \QmX��J3YEݐ��s}�a���r�OG<�l��k��w|5E�]� �" �����/�mi�x��s�Wb��Mޓ���4W� ��D4�,[�^��'�|�b@F�O-��44�` X��b?]��ktZC��4�j~Y[���YF^���7���\߸��qg}�.z�N�6C2.ut=�|��U����<(��kq%B���4�ͻ��as���v^����"ֿ�2ř/����}.�����\Q[h�R�F+�;O�\���W����YwcM��Oх�rj.��mV��^��� b]D#P�4��;�[����STܗ�w�нh!v�n��2��2f�����MI,�7z��]1g��_͢�x��V�|nV[����[�`���/�d��������SQc���u�
Z\B���\aJ5p�t�j]mS~c���w�r�� ��	���~l0�n�4b�0��E�N��9s����-�u�n�|�}�K��Z�:H Y��1�밅�F'�rI2���Z9�w�+�_^m��#vP����r��l�b޶�H��Ƀ����gR�}
�z���vj�m�J+o�TWp��7�q�������j�C����Y�i�hc-'L��2��l�Ķ�`D k�o$�O����e�m������^��O����o�X�H�_���c���nϪ�l���SPC�RO�u���	�r����i�Pdvߊ4R��c�����N���tG��s������ў�N�D�+S�?��z�|�F)��*:T�P�TQ��Ϋ����|��H���m�$tp��yw�}�*V�����w���0��x���5�!*T������
]��Wdw�:������#�A�4��9����2lK�ܗ�ɑ?�o���9�x�my�Xlg8���	e�JN����\w�]6(�-T<�e�C�/;�'C��'�Y�e���W\f@�a��I�;y9�]�$m�3s	|���3�|�Bl�'�!��;�D�.z~_De������a���B����yY�PN��F'�vg����$WC�8c@o,Rk�Y��*#kc��fn��#b���Y�4�v�Y &Yl���v	<��"����Uv���ݠ����ٍ���y
6C�!o�tR�Zɰ&
�u"Ä�Q�M�ЇNrk�m�:E:���x��[4x�Q�lc����mu�nԫ��_L>��jSA�UN�Qyk;��\�z鲈�[D�}��a- ���K<���~����!�F'��D�r���tFW��}&�E�ڡx����vEp6��>��3�ʝdp�v�����M�g1����	��`��=j{�X�җs�K�2����)��O.`�,tς]��ީ�f�z��ܧ���Qy]C=��Oт�_b����q�{۰�n��F^��lP�IqO����E�W�|V*J�ZǱ�Y�8{��l�5�T�ƺ	���Hy
�Ho'���*4o������C^�x��/�ڍ�:}]�i'c��p�W�w*3��������bs)��]�O4��m#�ZDBJ������}P�e���^yͮ�RZ������ߚm_��J�23P�(1������oU�#o ����0y�⮶?ǔ���z�Oo��/|�S��FH�����<���r�_��f(D��"�@��e��5m�=7`Aw�R��R��Է�tz��T�6���a<xc:��Lԃ7#�ϳ�n���s�4�5���E��*B�U6/�^��O)V���,<��A�*��q�gW��z��r�[�8��"���p#�jhoU�����>��v�3��DЦ��	o���m���[������$٣lQ�V"+H2�X�j;ü�oO&�g�˖�_�����'�3\�B�ጐ�eI�Lى⇁�^TS��'�;ƴO.z�������Cq�<����l�\Pc���7���V��i(���~���h�����W�Q�٠m_�f��O&jz�&�2r\��5��APZ����fh�@$��C��N��<��}��Z��!Gm%�'�3�b��)�!��	q��+uW�i�_H2`�%�0W�XϨ���lJb�Te��aE����k��ِ�dc����ECO�P$����Z�gH�ˉ���e����{��j�xR��m 1]4���Z�I�r�=h�<琪,�ne>5��X�Sȃ[�S�����Ղ�s���d%	�6�FR��Qy4�G��V-��9�>@��w{�ף�jG�&��	�rJ�=��j��ZoKe�t^e�}�R�����c�Xڷoݺ���cP�)A ���.�BmU���!w�a��E�ހ�BE�p�״����:�kzP3��evƣA:B$LߪxRz�2��{'�|�4#����`��-Ho��N�N��Cn��)1_�~�8��*����ҦD��=��v-�F���5�9�L����1��gR7�Z�`��
f &�r���e6�jZrd��=+$��OMk���8��sRjN2�Gx( \��Ԑ?�qj0?�dg��_T�'ym�ֶ���"�H���v�]fc����V��a���>�y9]�˒��T�'�Oǆz��i��>����΁�R�)nx�ؚ���Cg���V��T����#eA*�v_1ei|�'*����l45b���&3�)�U�1�OaI�V�Wt��^���~i�̨R����H^h1�۔y�Q�Iԋ��, #�����h�9V���vG�qh'cǸ"��^*gB���hL�F����#1F�X�5���w}/�Izs~�Ձ,��_~�k�-�[\�$��mA��\�Z|tc4��M�Q/�x9�Ar��9�֕����̦�t$���CiOq�PH��:BrSy�s�K&;1�dR��)�ԕj&ș�P'����%�M�
�[PdL��+�2�@����9��Xq�&�x�	���_�-�{�^����6���ͬ�(���Vf�M�rOaj����x	�~>.�݅���]����xDȚ5���s�V]�d�;�;�i�e�/�^n~��:��AtXw�tBT�#Tu��i���B�,��1Fj���>+_�I?n�a~h噶����p���[Ḓ��[��cY��0����%u����*�4-I����^��N�ВU���s�[	߅��p1;N砤Wϊų�dҬ7r�}�&���;!��Z'��#���l��=���ۊ�����z��5���;ge��y�ѹ��#���G���"y���<�t�i:�V�
-
<4�9u;�f!In�9O�׍��i��pVo<.��b��������$L�,�=;��/�m�Rjq���k��2<ݑ��9��E׭�Y��
K�0�lP^�M��)	����!��5���>���;�O)�)������39K'y2Wv�l��������G!,Rw�Ę0z���n��.�6qՃhb�n>#`�)�&����
��$8o�K�ߢ�[h*��~�A���	� H?��Y:� ؟O�בa�sY�ؿ\,�>׳u;m�XP��}t`c%�9(��h����-�NX������k�5�=�" >��]�MO�&xr�FpK�pS�_��d�F�z�م�y!1G���������a{�t���7�~g���@�#���}�����	�>]u�G-��Α��������;�n�����i�!�Z^Mk�覝�6+P��u�+�Ksݶ����~���,`������k�t�ST3��0
Ε�ʓ}^����!���&������m|�:m;��.:r�(L��L@4�b;vY�-�(e�!�mi��_�H=V�Y�X�EY�H�bi�r�V�O�5I/�L�)�1��d��"b&�Vp�Ztm����
a�	��)h""%)C1Z �::�Z�å�)dcNCdF
D��3����[����q�f9���;�݈�to�9Ò����P�w֣�=��vVL5� �z� �V����Z�v.�$\Ó$0�-��H�7>�O�vP@g.�9�Q1CpZ�t �x�_��dC;!۠O�A@� �[Ђs�e�сaG�C@cf�c�]��c�=z���q�N=����ʓ%�Ti+�t1+M�z����t�g����1<]�"��HFm���
c�6@/t�47�pM(�h���������nqI��/�����ڧL���:JV[�'w�7!9�� m�}_/�t*�u�J�Oy��m�A<c��� �p��E-M�����ާ�-���Ra�N�P>��At@����(V���B+��
�>�ճ�:����q�F
�;'2���H����?@�c�o2[�ZN�Ƽ����tÐΖr��/؝�0]�֭ �s �G�F�Eɹ�Z�|-��S����tq�û�oz���oպ��ӓ��C:�J��'����6�1-^2"���<!p 8����`��T	j�n֍�p���V��~�x'��Ѝ�b����n
v�<C��U�V?$�S�`cЧ�ѡT�9 T�oQ<���nq�z̻���0f=]xQ���dlls�����iHA�����d��B.�Q����]���s������G{w����w�\�}��5����ׄ��cʁw��ܼu���5�����?�ݽ}��'���?�����>v�����w7���������j���4�n��Ю�e��=�,t�,�{І� Z
�1 ���.bv���F�dd��9:u0�V��:�F�UU/l��9dԒy���b����� ��14-K ��;V�抳:h&8A_�����+No\�?�kSO��1�۬��<M.a-7
eEJ�l�;6N_Grv�D~��EՐ;Ig)��EaI	r�#g�t�XO�t��s,��1��u�Z���p1�If��!��-�3�ZG�4�RG���R�l�G�HF�쀗��K5�R�C{��������PM�1u祟e��k4IE��������d:t���6/�5�O�e1����h�T1q �=;�F�}9��&Ɩ�2+m�|��e?jN~$�Mb���6����}Ҥ�ZaÏ\(�_C<WR��a$5�p��.���g=��bUۭ�y$;9Ix4����TI9#Y�^�R�U�`���l�Շ�-�t�E:L'ߋ��*g�����t@C|��aN}����.�&�g��M+��p6��`Q69	�U��Ȏ�D4v�N5�y��C�3�緽�s�a���>����Z����?�?h�?�]� ϟ�9E�NNA� �n�b�t:W����Lk�>�\���-vX-�p�/�p+V���%��:Ɲ�|��n�T@.���'�����-�2��3;�~��´_3��F�h�������\_�&ĝ%�=Qp�ND�Ev槴����������ɯ��=_��T�N�7Cn7����V��ı��n�<9�N%� �7�bO�ϙ��t���]K<Y�t��,Y�����C~m�M	e�N4���H���(w���?ء����|�@�Nv���������|PS��
�]K�p{�ʶ�V�R��q��(=������0&��wj"�	O��������E�RQ�+��L��,o��H��dw
c��� h\��7{�f7��U��$X;S�tz���7` �W�
���;�ћ� ��9�|�Z�|�
��oK)�3س�	(5�X���78K���eN��̩�dpL� m�9��qe&��@p ����+��D%X��Li�%��zx���+� ���|��I�����0�3��Κ4;+Nš����;-W.��+!���,z�I��{?d�����bZS%XG~�ܸa�⩾(&������P_�a�V�����������R��`XB���|ٕ�"?,��m=�P���Ʃ[�F��_U��G���n�~�A������z��	`|�=��	M����*��L�s_T�ƜC�,r�Rm@q<9�5	QW�荱�8��=�(`�}#����ĉ'd2&ů��AK!�A� �G����;5��@ʶ�S��F�}���zkD<������I���0�W�k��a�u�]� ���5��F+�:R�v,���[1��PRHJHa���d&�(oa1z��;��ʴZe����6��D!)t�=7\�7O/�~Ǵ���zis"�bmտ�ט��.���/���>��cazh�Mk9{Ղ���y����Z��x���1����L򺧟N���I�hcLު�hyj��8�������uv�7�h
B鈴r����ťzF�Ѳ�@����%y��%��Ϝg��PM`�#k�����
�
*�Ǿ��`�
cMA�La5���]�RB��38qz�2s��~�E������h���ڭ��`�z}�C%! HN7a����bܕX���V\���M<�U�O�47Ւ���A$.JG�r�����#R�Ll>�5M�w��T�'S��4�e��/-�C��1l�.�5����a��7��jt:��&����b��=�	>b�q�Nnnl�a���K�e�ۤ4��p�4#1�������n���E[o(�6�>�Gc���F(���T,U+��lv��[�!���h1�;8,�g��2��ϓu�%�J�ϑ��v��'߲�����#=�b��1�I3~��#5�)��d��t�L{�?��u�����G�������Gf�0,ܵ���+w+ ��"�S�r�gSb�L�Ӈ����Ʌ�uW�,1f	��j�v!A&d4,Djvݶl|�_m��[ �s�6^A��s{S��f>q_�o,�U�k�S��,�/�w�C�N[�\G3�-|ä�Nf�� a�N�놽�.x�a�	�F�������o�W�P�rEb�2})�J;]yBl?v'w]����hi��J����e'K��/�g$�ȹX���I�(��5	'�;��S�3���TN���cdq���H���-��'�}��}@��x	T�u��坯�H;��
��u��������}�G�`��(T�7oʚ�5p���w4��x�x9Q����-3�]VԆ��[i<�A&�@�	�aJhO� ���H&����N�N��s*6 Il�WEY�޸�6�0���%����іM�>]s�8���LZD�B �:c��~ ������V�-���.:b��h�='��NK���e����+_´!�-o1R�T�Vj�2ۥI5�a)�Xi�Y�w��XdT�.D���%���I��r�R%�Î]������
�0>�3���Aä�ڔ�a}��J|�8���2����V���J��a+���^�/�#���KԼ�Dˠ��%���9yw4A{U��8�{4$p�#+#"���rVU�VYO��&���Mám�M�o���25H+�a����������B͛����A
�]���ݷf)q�`Eʹ�lU^�b&Xb�|mچd�HWk�-�����ڑ���o�V�����)�+0��'�AP��إ� ���ǻ��/w��|y��!;z/��܎+���v͍a
eg�����hy�!�f��>.i`�q�V����-S��,���=�y����1�!�����jD���
N�T[�f(M�O�.�͘�|H\�f�P�p.^0Hw\w�1�Ƀ�=�������8���K�r�w2��|vV�ʸ�^�7"vHl#���ɘ�� @��dm���V���x��V0��8�Wf����J��Mf�PooxK+�%�L܊��I�p��' \f��Z�z��/�E�*;��bP��;��s����Վ�񖄾�
*���Pm�7�}�=�?z��z�2�ՍO7oyϿ$�-��^���H�ݵ�L6�k���c�&1���H$�)��y<���{�U��r[���%��\�O���n ��Kn��;ò�&�5Xte�}�R�mo!���t�ᖵS�A�e��Z�jj�߻�Wz�]c������E~�R^�y�坊�P����$)/DG�5�Zm2�[!�rd@Ύ���w�5�9��P[پ遤�Ym�0��x�(��HZ
�K}���#�p�����N�fo�M�7��z'�������މ�l?tF�\$���fx�<�^�Ȍ�������_̸�����5��騊[�uH�G23�f�t�K�G��t�!�2�G[��T��<�zs>_�ͷ�R��5��8䭕�Q9�ߡKы8�D�˙��N�ޞ�j&���j�+p���tU����v�oYٷ���[���~���� �"�]!�AK���� tM�0�.��`���=3Q�HG5���c�qhҟ��-�<%���2t���{��	�����EP�y����Gx��� ��vy�_{�Q!O�kʊ��� ]�=��t���J/՚�81ʼA�Vc�. �s��:*6+�m\(��=3���������(��Nֿ��h�zfZ?�Y�9���x���*bJ�!�}��L`�U���a|`Z�굣>�&��hW-��w-�D��l����֤u��"�ؒ����3���P�tԍ0�&��O���v܀¢g�/���d�o��եu�ֺ��_�
#���HZ �����
5�K�������W�`��}�s�������_����0*����0��y�N-��(;E����+�Z����_o{��'/��T���۵�˛r��*>跉s����"�G��SM�����D:s�:#=F!�W�[���gEf��m�N�\�i~��9"�6��ދ����pi5������2�7b��@SÜ!S�>�3�~+z�5QM���}�������?����g�s�/�O\��C���{w�߹���(�˧�����Ƨw��_~�?կ��o\��q������[��ﾗ�������2��Q�~ �߽�w��>��Z��Y������Q� ��۷���>ȯA�����O�\�?�_�������߸sk�n��߾�q�����	�9�:����Ex=d���Y�X���^[����7򝤬 {�C�|���Llk�`�StKk��Ǚk����04�r�������"C�7���%{�>V.SE�R�S�/��y�{I�l"w�؍�Q�1nk.s��g�;8�jԘbi��[P)/m��`��x9��Ù.�O��1��I�^6O6����iVM߉�����d��ի-j����}�u6��d��������`ױ�bdFjH�2<��@�f�naT�L�3ʳ�!��se����n@�_�h��eqn�E/�~�bY�6[�����5�����n߉h�@��G�����Z�#��v�|��#HDC����sqƃa2�y9�>�{�>,�:^B�N���4?*�F��:�(+Z�׭��N5����BW/E�$n��A�}] :I��ԟ��Z�2����"$��De~3+������Z��vvn� c��\�>�˥%����k)�<��F���rX���L�!��1��3-0�N�DEUum�#����nT�E���oҳ��#0�/����y�1k�ַ)g�N��A���~g+��J�͗�]�"5:WIF�lQz#7"0$[�w�yjtD��H���k��`�E+�g�f��r��u�͉-P�ͮY��KIF�����D�g������Q&qCr7I�Lwr�[=E[-��	%�eF�R�v��$C�Br9V�Xp97+"���e1�xڃ	�ld�:8w��.Mp�mΤ���B�Y��vF}]�6GK�Z��4�7�]�EA��NM�.d�!ir��Ei>j���d$���m�=G��3ʵ�A��/�U,��b�>�>v;(���ø�-тZ?�Q(�Ѻ��Z&{d��m�2��������R�L�_���#U\j�.r,0R������?�_|,��[��]��?$��K��[	��m>6$�	�x����kX��	b��sZ�[	Q2,�2y�VNr]:�D@�&ǁ-d\t� j��M�#��25J�:02���ec���O^|#I�Ϧ(����y�d�{��I�0�+��3J������ZkȌ9��UN�d��O��EGo��(f�%ؗ	��<�do��~�W�:N��'���({.�Ho���C��rə�����N�23۫9Y�O
�O�B����,�o�j�b��a)��f�О�a��A�������K��1.���Ivh +��ޜy�ى�	�f�L�ar-���<(D�ǔa�"����|��&/<���K
�e��"�m�)X�a�p!&m�+,lfZ���^MUD*Ȧ�]��t�^��55��#e)6iw .�Z+hɰ�qh�0��U�L�E��Eeʉ�$q��1��X oc�)�HNB+T�8�L�Psک��>:,�l1�Q��&%�jsAj�.H�����*5a1?T��Un�.�|=�rF�2���(���:&KP�d�*b!Zoη�Q��
� 28��5z(�K�x�Zb� �)G`ȓ'������g��B���3��;�a�C\#�)�.R�d�͛����|��@���f5D��XR%�7( 3�a��d�0��K�M���ut�)�zF��I���+�#�������O���L�O�D# ;n�'��҂3u��kL�b~�X�a9E4�޶�V�I���|W�(&v���p^�Z�D�ƍ��&��Z��S4��*��Q�����G*�1UݲI	#�Ͱh��|||�p{$-�������W(�Z�0K)"k����B[(��S^�P6I�#@�a[6�ADH�]1���hQ�-��y�(������Ҕ���l�X7��[M��K+1�M@�#��;8æ3Lqڝ��n�)����9N������iΜ�x�jC���ˈ�����vOo�xw��;�o_��}�ߵ�����~ޟxw����m\��|�_����'�l�l\����vտ�o��������7���?��ͿM�k.�_��w���ܠ������]�?�[���?�xw���w7o]��נ�݇)������������v�����;w�o���������g����í��jה�m�L2�H2x��ʝeeE�7z��O�n�4�l����l����=z�˸R�M�ћ70g}����퐗hB���Z�2���[ڑ�e0�\��tx�j�UOA
x���uQ�?�.����Y̪��Or��SW��0��F���-� +|qղ)\��.B��]��8�|��3�����l-	ؑ$�Py���c`��Hn�t��mzD1������
���r���&�oа�Y�����Ԙo,g4�51���?
fwAw$Ov��f�u�0i[�"���"��EeAПY�k�7S�|t�e�L
��y��8/��yZ"����	[g�0��dI�X����$�Z�"��{NZ�K��[*N$�L����{��-M{C��L'�1��,i|�@RPis)'�o��')q���t���s���^��>8|�F	��7)wi��I ���M�}L��|%�o���d)�\
zi׏��k�\3�Q���)�R1)�#��%X4-��Ϲ,욙�P����ݒ���}:YBi�GDd����]��U}d�1�z����D�w��%_�$�}��&Ώ�m�Z5��n�d/J�āݚ��)���G��o���eN��r9ɾ`��2e%�!�'����y��q�&�����e�Z�w�<��9}�H'U��u�/~_٭�I&Բ�|�bG��e% '/F��JRHa���횗6�T���<G��D�s���%AVQj�@�&K�4��]n^e��{�eޘ�����vt��J�yZ)�DI�o���*�����~�7���*�Q����e�3R��q��l��)���C�]V�~U��}���f�_Un}N�Nr�֖�`��W@x�}�q�.�]�9ޡ9��{߅��Ͼ�`�ӡ>�M�05Z{o�������)���P��V>*Ѐ]���W�ոB�k^�Fw��O�J�.�/��E�@����/6uV�I�&� ���_�� ��^����u9��X�ZC͘� Ȩ"(߼�8C�1k_�՛�7oԫ� ?L���P�S�Ql؆u�]����e[PU�߉qf�o߮�%�2�gǽv<�=h������轫7o0�T��7o֑��1k3�¼m�_�7rE�d�E���#���-�y3�4KKҾ���֏��D^���qU��*�|N��+~�?Z�N���$�ɆEn`��M��(eSB��Fvn�ģ_���C#k��Vp�F��q�a���dG���!:��´���X\��$O�L���1�]'���4B��ܝ�<���N�1=��!%�;�:�"�Y���]�#�*ٵß<��h�J[�f����!��њS�;��7,����?7�?oӟ�!������y�l3I������>�ܖ���9>�_��,�y�l��Ǧ�#h�y��n%r��U�wf��6����פɯ�=ɫja[�?6�A[��k
=H�3�7t��������1|���T��)iP�z����(�fz9��w��:b�	�/[��^J�Zy��Ws�ukY|�mx�D?�$�WY�O�u�dɋQVr�$�����e�q$�Od2(�l=���aT��ӿJ�q��m�`���It�F^��6	:yq���E���Aǂd�d+��:%�#ֽ�Tv��[�t9��UصIR+9`%�!���2A<ü6'*Glnr�&��r��k�z؆$ϑ8M�U���Ar�+�
����_+%Ɇ׹'��T5`!�L�tė���qMh����|����ght�(�:;�F�u�Km�d_�ĺ�"�PѺ�$&q����Cci�9��9�����.mou�]b��Ȱ���'�~-1;'��4b�ρ���D�I��$K������`���];YY�)�d�}�s4�H_��Y�?)���r�[aC�*�A�2O�P>�Q�RY٬�B��E�I��o��eE6E?;wX���ׅ��eE�Yz����z5���"�~Z�B!�ɡYh�����@�(C�Z-Y�� �9+k�^D6�:���Q�`�bqx?l�#��ЂaŞ�j��3�M3�X�i�!7c�:���w:޸�%�-�.����K6}c����3̙=TMt$�o��Uz�U��B�@^�}�3g�f�O��b�9��	���he���þU���<�)�ֲy_�P?�co,8R��(�e�o-\���d��C����S�;P����]��ǵ�P���<�OJ�?�e��Ck��Z ������'`#���1q��5�P]z�)�*Z����Ջ��߼ۊ�-+)�U��,���^mK�^Gtg�:\��N���|��1黡M�z��Nzdt�˽���23��C7$�1a���T�|f�Q�bd~׏�X^��֘�<E�Q~P rJv�������,o\���էԓ>�x��l�r;#�C�]��m�d���i�j?`��J�U�&�6D1������hqA�3�Z��1�r�|$7�U`V4:X�7/R<[4.S:94�W�U:�x;�Y�|���U�|�u�ो��w:�n��E3�V��t���'���)�\�4���l`�+���p/?mZ�X�8��(�pe!U��G���,fr�^���i�	��f��M����O��c��-kS�VF0�W}w��t�o�O�� z�/�|�u�v�����u���7��A��β.����a׈J1߸T���k���T�I����x.xV��X�f�2�U�H�����?.��F3=��z\o��\'�z����@)g���A���������v��ɉ��xꆮ���W4�O�`��j*���`[k��^�/�*��2(��d�$ؤ�{� �CM����F'������s���zv�������ޘ{K�Iu��bf��)sZsu�Ƚ�:%ώW�����%�����Ag�]so���R�&:25�~C�'\�r�V�<�Fac3|^M�X)^C��c�,Eϧ
� �c�󯷏�k�q1O6n�ȑR���pSZ)^��������r���H���=����̓��V��zq54�%����a�u��v�Ȼ�V�W4r�~��
���M �`�n�����j��x3�����W��L�}��]�Ϝ(�^��z����Et��ֈ�cE.[By�n�#��V\P��0�����^�e�^�+��K��4}��h͝Ւl6�.�nF^H��*�a������E�W��H�+�i��}�^l�T��3VI/�HM}�U�סњ���V�G1Z��`�4̝��
�,������6�hI���Z�e��	��@�?A_������@���ߗ�}8窙f2�?b�N���iȠ�?w�����L��yG+��g冓;{�;�:
w�Z��O��e���Ύ�JR�~���ފC�r��m�>=�k�%�v�[kh�=�į����H��UX���U5�h���A>�����<��sy�Y�~=�C�j*F�+;NXYO�G��%�M\�WM�<3.���C/9�-��H�[����I���\o��������$�<+�#�<�.�i1�Kj�̋���'��m��W��Z�U�5�.��L�1ݠ.t��dq��:��/\� �F����g�g�p���/}�	���F�O��r�����fa���q��x,Fk��Z, ��ZL4�X֟��������nQ�c΄_�Y�-g�e:p�9l9[ȳUI��C�z	��.}m�k�M"oN�NX%��g����S/���i4��^P|�����,
�&Ixɕ k��"���H�����ʘQh�KU��)��}mh���-9�X�7��^�I� a#-9#�?���(�ձ��#ŨL�V��pj�qA1v"�v�Ȳ�v)���Od{�+�r�^m5�=F�K����G�y<d���M�$#A�0�:�U�������r8��� ��@��j����ab3Pu���a����c6�͵?��L���"פ�d�9��Qi�E��c)��8�n|�e�Z'$A��o����}�:��'t;�rp�ō�$�����΍�D�s&���/�r	���6� ���A���\.͏�E�OV�=YSI��u��!e��3�m�
�R�ō$�\���'�"�f��})�6��Yk\�(CR!A��Bw.j��ī5�����o�{��FTa:�e��xa���� hxo�ɜ�ǔ�Q�)�yZ��ǹ�n���JO#*]��K��/���!N�ub�9-q�M�����	��P����N1����ʊ3��sx��٦I�ڑ�s'!�����f�;�0.\񻦐�X-S&6*l����+m��ݍ#^|�ȴ��Ĝy����$-�s��u���J��\���� ]`z.�6����M@\�
�����4��n����64��,���7�����bE��'��"B�s1$+[�ϭ�!@!r�2��&�O�Sġ@<�Nu71�d��"��#2�
�#s(��a }�R�h�Re&� ��r�-z������B�A�A��ŶU�C��)y�7�*���9�oW�K�3�7o���Bf~H��h�w�L�%���s,-q]P�pR4@Ӗ�m�1�{�����~�_�s^$�/��;�'�^�}��5�������G����qo��5���5�~z���w��?��現�_��y��� ����������k��$.h��\	�����?%��:�D�����~^��Â��y��a��T��]j.dc�9(wg��4,�|��d㸭mΡ�� ��kHSS����dz-�٩ _�'�B\JwM��E�\8�N�e~�擆.�6��w�D�x(��W_|��:��~�$^� �:��v��%�Ōjh��_��Iw2]:[��px�[���0�:-��l��\N�z��#������@"��C��gσ����>����T�n�~����˪������/�c� -�~,����A�R��Ћ)ǿr�O�W@�%]��8���I5(0��Z���GNF�
A�ԊGl�/��u�S�+����R<���2O^RG˞2Y��8�J�|�rJ�>/�K����r2�0rY���G�U�c��j����Fw3��ezZ��1Z���V�/�U����H�1(��P�r��|�� s�g��YAɓ��ڛ)
��TB�Q�$�Y`���_�4z⿿��k�Z�f�x+�O֍�Vku���L�ys9-). a>L)���b�k�L:7��I�ؙ
ְ����d�G�^��KAM;�x���Y�W�î��Ƙ*�f�HHY���q�0>O�L�$*����2P�����'�m�q�h�20����1)NC��0�<�o�*�.k&�)�Q��G��:���A_�|�I0b�(����<e4;���1�I�:Ti/._��D�in��|ThÊ���]i��i��.+N�u�� ���l�/�k\뉯�hLE�:<f|~����X.�m����*�V�S_t�z�!�t���+q�ʘ��v̱`�oh?����TkY�j8�$���jf#c/����g� � ���&�����<�$_g'�'s緪)���%�T\��d��N����i�~P[Y��ߔ�ClNx�W���ZW�ƭ��p�&`�:#���@>�Mʓ�@-��uB^T}�?�2�o��M���+k^M!��@��!�I���\Z0OZ	��:q�[����?/�-�9"��Oo�k�/�rx��E�3��X^�qZ��A]��r���jR��M��C���Q#�'�!<�G���4+"J��yp��{�I��5���z)[{=P.��ۣU�f���sn�gR���\$ma�m��t���]<L�K���]�F2����4�0[�6� =���X�Ao�n�!iL�@
'�_�36��Ɨ���P�Zu��U�O��[��|�i+��f�?_��W��z���A���=+f]���������d�hP��o�zM�I�-�'E�+ڠ���������"�E����4F�UkPDئ��)�L�����qc�9��\�,��*anr�;��K>���OKf�,n�PY����nq�	��!r�xԺ�)J�t���ɛ���m�M�Ur�|�E�O�
�&��{�A?�SZ���Z��;��Fi��a!SN�_�IZ�m(�c�~y�~�yv�i�Z�q�y�xA�U�RzFL��Ye�af�� �M@�۸�
8�$�5��j����[Ľ���S4�rB��[��2��CK�Hkl���!��^$�P`;&�&I�d��R&���U6�ô|E�VY'���A��8Jwa(�������Ih��{w����H���C� �_�%g��La�5GY)%��?��mUŬ�<F�Q<c��
:�e�0^�Mg%_���*t1����'������}<�&�:��t+�=VO
4�,u�/����%yb��;��M��j�}�"�S:G�����z��	�GD{�2K��,���Eo���ʷ�[Ёsx6���K�}L{C�FQ���g�QN��3d�瓢*�c�6�q�����|�w��K!�'f��UЛN�D[X�ԗ�dIW&��c�8��Ag��0�d!��׮��R�%pP+ۤ4�:̺���K"嶘+�u/�)��q�}5��x �h�N�a���M��:P�>��A�/AH�=1�v5�4����<���M�C��#�ͯ´��cN�_7�B��V)a
��s��f�Z4�V}�(t��+�/�}�U��}�� �n5$%W?NO����2�DxE`����9A����gk�N<�.B�~�����z��]��t�����l��2ˢB�kv}k'4ۣ|�a`@\����7CI�p_Hl9�V�&u3_��
��^��N
��88�8PؒG�Z����}����ȑ(-� CG���I��h��V��D��i%}��2�����h���[�^%�>�t)5h1qR��C���|�)F��^�EU�
O�����~�T-�0�`��������v����z#S|��FlfOJ��J� }(��_E�B�UFM����$��h�> �
��C����&+(�'��~�O�mOǠ��S[.ɃZd}>���s�b������/���ż�k-_�Z��Ìu��U������:���\�\"Y-�c�˰��(tI/�C
��0�l���䷣Bf;> ��w����ζ�n�oR�T�S�^�5���u�T�F�r��������;$�7(�	�ޜPLk�5e�qJ�w���0����>�>�2��A���k��<h�h��~�4��B�d
�(���eA�f���e�o��Ᵽ�&��B��5��bO�V[����KJ�nk��r&�vn�.4����Z�A���+[���h��ɇ��Ÿ�������د>�k�^mQ>6�X���|�s�w����4y���w���^�Ef,h����i���ӡl��wd]�n�]Aah̡h��}�!�*�1٣������C�K�;:�����l&�X�q�c�
�j���y� [T%�³K#�Tf<](T�b{�1�EDQ�;-���%ImΔ4�_�ԧO# DM˱�T�W �s4��ʼ�T-jŀ-0 ήܗ��h�g��@�F�/��o�W"X�vL�p�b�:f�|d�P�l�G��
GL�����__5����
�m@�.���"uꃍx���8��R���#`axB�g�K���WVW݌^	�m��j��k���y[�U�%��ޝ�m���tȡ�n��4Ц՜o�+��ߞ]x�W1\}�s	%/��S�����j�����`��M�����[+��ʪ,9A���oV���ԣ�/�s��DX�I��#3�[�;f��`[� �5b7 �'`�JS�N�ѪZ�}g���׵浐�"V�ت�0�f�vLh��l[ȍ�8��j��5kE��p����:�Еj�$�-&�����&[У�Ywbe�e|M��+�`L��mb�d�!륯����B��u��8�UgO�y#P|(�,l�%��H���
���-���zȜ������2�u|��Rǯ�i����lP^��Zsf߅�	?�Euu�a֠�_P�^���Z����g]F�����By���^��i[GU7�T��z��y�~A��
xc�^���b������e=$�rO���R��f���m�����r��'��Єq������['C�B��<��������f�%Oͻ�`9�l�I����qw�F*��.��3�IŁhY;K'=�·�����a�	�iE�YЊ�������t�:02�:+�����{Ow�݃���h��/v���={���26س�E �j���(>ą;%m�C0Ǝg�u�P̐���ѵ�|̃��㰌�Pl��oM�c�Aʖ%Y�ѫ�M�l%�N�yc��EНf+����]Cʩک̚���o�k��Qܣ���f{�����`b�L��P����{�n�϶s�t��+��U)���&v����>��S�Q��M���J�D�&�3KT2�+���q�ɕOrvq��������-��ф_�=\�*9(�l��D���W�D8���F:�}�H�0aD��y����������J��-�9|��x,�h�y�b�&I�:��$}p��u;�8�1w�Y��@xHD'�K������%� ��w�w��dڑ|��.X�e����dA��I[-s�vts9���>��jqZ{��/��z7�8�m@A�UĖ�����x�{��z��qS�d��}�[:i�\vrT>�::��{�n�V|b?�k-.ʜ��p2�t�}{��w"j��xD�J��� �?Ы�q���
�6�P�P���o�vT������
ʴ.S�ù�l� 8��l��&5�86�l�Զcʝh������^ߛE�(�%���������G^3��o4���[�D[6�z�x�����K��c���V��¸�\�* o�֔�_�v�/�N:�����=��,����~#Z�e���D�կED2)�� ��b�SNc>g���ѵ���ldH޴�zAĤ�D;�ϭն��8�B��͗��ycǔI���x��߇R�.t�7yHq+.��6��ҝEQ8?�f���sm�tD!�(�|o8w(�r��y�a��D�����J
�^�(b8�ǨA �G��e��|��H��y<��?��y�}���#�-�L� ��~į�2D{��"A�n60N=��\�.�8lL��5b`+���!���
@���'#�Yƾw.���x^��Z�l%����;��g-��X�q{���47g)lKK�JŁ�>��4�+�4��p�9}���j&�^?�	]!�+�:�/����k��	�[�1���5`�V�v H}�[��{����j֠�3N�T!*����zf��J\�2�����p��N���@��Ui��i'V.�=��F��{p�MQ�=�z�%(����g��_�1����[�
g�����E�uԇb�Yg�>B�:ѫ�X��[Jm
�����e�%��d�"��̰̽��~���V+ٳ�D
���iv�
3�7|3�4v�O����%����x��;�?o�ٸ�y���A~���?�C}~r����?oܽ�y���C���ϛ�6?����k���Ϯ�������?��`��u�����%����7�6��)�mFy6v%O�_����?67�ݹ��>��Z��Y��������������}c�Z����os�Χ�����n��������	�6��?������)1�UC�Z&���D�kue�oȘA��J��~���|�n(�ʧ���p��>�F��_�+4�}��^Пm�A�Bp�}������C�^38`���Q����mr`|&	L��\�w�ͥ�Zu���ޠ^�,����l.r� ��(�y󸅷�Q��R��-��lL�|�Xm�iL�������[2��cR�l�G'C$�*��$�"' ���_�mҵ�
��
��G�F\���+u��V�͚�Z��֏M�v�}�ɗm��M��8>xq���N�Y#2�E�,�L��l�=���Ko8)n^��7���k��t���'�v��K/��®9�C��7W�^���f�y#��t�kU��U�����.�+BG���^r5�w[���	�O���?���"����.��Pv�:�{>�ȫٍ�RȾ�$JM�D�k��K��e��W��p�'����a�V�oAR�i��j���҈87��\�Y�ǬH8C9��5{�t�w�sBQqd��qH����IԻSdk��Ϧz���� K�,if
�H=H�\�Z&����M���=|O�����8��s�����Lڈ$�~��+�b��$[|�։zh���Y%���)�GA�(6tI�b���X2rGݘH2�;|��Ў�E ݤ�+���M;}����������6�d��z�M��A�fIflx�i���%���4�&���� %��g�����6O����YUY�ui�Eyl�ǌ��{eUee������=����)�9��8�@�)U��u��PwT�E�Ʊ�bO��r�YA?tQW<��Mw�3L�buB 3�ϱQ����qȆ�i�=� ZgI�r�s�P�ީ����OJ-$z��Go��ID(*�i���>A>8�J�!0���̨<��^�f�ۡ��0�:��NYד���l��w!�$ �p%8�G�@g������o�uӺl���kwn{AĘc��M��$�d����Η�X�e#�tNW�
���[&l�to�N�-�����y�X�K\QY�{�m;�pd�p�:pQ|u|z ���-�Š�nY%z���#5��4����|V���-�a18+G�@I��O�e��Ӟj@���;�<�o(�����V�0lY�SK��� �ڕ��=�0U����.�A:���XJ�����&���Ƈ�K��P��b4Xj����K�߆��)J
��ϩX����%�,��=�q�s�T�le�5Rh�l�c>[���/j�R�#�L��3�w���̺�M��/;���-�S4�4��T55@�ް<Jͮu��Bk�t�m#��V���)���?�뿳׍�-����*ФdG�5�!�sn؀2�������p-�q+�����f}��Ο�@��CIb}�&9���V�0.v��E�p��5z�ss�������~������uYԚL�[6��9�� Z
K"%���ѵ���&h'Kl���v�Լب: ^m���]���M��t�F���(5�PL�;h|�Rkj�8�-�D�q�F8�0��������$	Ζ9w�F_e�6���4C�5��p>zk5du|���m�GKH|������A]j�fH]j+�����]������T`�k+��v&V��l-)�<^e�n�}�K��f]5BG�oس"?�>Aَ�_���$������͙��
���:��k��ܹ��ͻ]�@h7�w9b��`�+�W��Р���4��@���Cƌ2���'e��o�~��%��7ʻtqUü諹eS����~:�X�Dq�����r0Q�xpj����ak�N$�S�L=�<��������z� �;��;�2��
r�����	�=���K���U}TLٮ������bEz��(0%��-���[-l"��Ө4�Q�bc��8���x	�����X�xJ!�P^��"�I �I�9���hLěE�4G�xτ�Gش;�{՘�G�����&�	�ŋ%������!f�pM�9���YC�H�>�Iv��1
vt�{��C+�pe�c\ug�ޅ���2Bd��վ&w����_|�7X����:�z�W;摒��}*���,�8|
2l�s0O�V&u���47�� �u�=�y�N~�H��`��3�C�i�^��o9�0n~���i�_4ۦ���f�i�	µ���|���vK�?޷S�����_��zM`��l�M��\��h������l��\��gUYx����˳��+�rզ��{�dG�˶���l6z�K�޹�k�u=Rc�x�r�cΧ6gM�F߬�<�,�_�Y���2z�w�t�{���uQ�6��tb u���c����Z"s37���e���@�����gPe���5���n�������y��*�vI�yMr�~����QK�+d�n��%[�Z�K��	w.�>�WUL������� 0,��O�{�{��~��P]����e��s�8w��{N��U����*���FRR�Y���~�j��a�k�煢�k��H��� ���7^Fl��kݧ�p�o{?B�W�lN�k�+������-��������Ǆv��}�-��������F�5"(
x㥇����G�s���ސ�o�Oj�]���l�c�ԾE�}\~���8w#t���b�Lk��P-��9x5��ֲ���Z���au6+�.xqp5R�z|�����v�^o����][����u�|l��>Y{�}�j����q��m������o��+Mך>�7}|J����>>��=z��}�o���|\]m�]]�>*��*�&�F�霈�00Wu�x�8N�e�i�zG2v<I���Q�>�ҤJGe�H&L�wHՏVu:�NY���)W�u+}��Z��(QkЅ'�w�b��e`�kgql��X^eEGS��ٜj0��n��$�Kwi�F8�����%�`Y�����O]����~A2g5�h�.w�,��e
�m-�U<<�˷>���k�P�L�H�J8��&Q+P?�������0�5Ẇ,7fD,wM0&қ˴`�!1���5!�{_s'&�ǆ�)ȷ���Ԧx��i�Qd���ė���U+P���n3S+��u�F:1�jA���m�w�9�>l�Rn��Nn]��s��[�>�끕�ؓF�v��![��͛&PݶL�Qc
t��^��'�������M�2�[�%,��m�S��Kᥚ?�t})�ۅ�_����?��+.�@�Y�O�>|���q-7��?�_�������?"���������{�=��G7����_����������c�߿�����	�gL
nY���ypO�˛kE��V�"���'��� x(�YS�&��Jݑ�0�R���Y�|�����e�{B�cB7��Y��(�/'�)�7�n�Y�O���ʮݚ
�l�����v�|!��~i�^��! A�	n��ƀ��޸$���5>��W[�}�ϻ�J]�
du�|��n���꼯��W &ED�Q/�k�l�[���"%2�M5�}
�,����˳�s/8�y�|��t��B�V�B�Ci�`�������}q�t�����Z@r�E&��!���]I�TV��;*���o����U�[���}\x�&є_���B`L�M#/��uY���s$�K�����-��MwL�����-m���[k/;:^H���#`��ȳ|k�6��7����ˣ�}23_����Y{}{w����t������8�_08�����Jx�����6YBr�m@~#"��I4j�\�!n�ڽ�s	_�v5�9���V-�bn�]=$4v���B��r��lfoW�	a�yzc(ei���m��	'�k����D���L�q�w�-R��g�NT+�t"��A�*Gk\��_�a-����Eg���u�����q����ly����ͩ�12��PM�E�&�Rf�w�'c1�Lv�EM���xh8g�t=HiD��C�`��_l@y����I[�u'�J� �(C,H��[׃ܘ�ˊ��7����m�������xT~�T�,d{��3���꿺��G�XA&�b���2�9��� �n��U0�l�S+hz)��V\<ͮ��p�8�e8���y[DHf�F~�@����� (�|夒΍@(CJ~|������9��
#K$@���Pi���X��(r¢�H��p�����u?�(M�ugq�;�O��N=Jc�������EL y��ҥ�@)ly��p"�:�}���ь����U.$N��"����0��O){J����[, �6)�a&f� !�D/?�^�x%S�B4�]�7��Q[xe怶��t��4�tb����n��DZ��w���Sz(��t-��a�F*_��L�?&�6g��^���v#0r����6�G��UG���x��'[��[��Ց��1
��#pq5�[�cm|�@[o98S_8@��8�[gj�����M3�M)vo/�������~>��\�H.y�C���}]��ɛOWf˖� ��F�e���gt�Ȣ�_o��k��?�'��a�������<*���}�8�����c�5r�g�¤?ZyʻzW�W���-�x�?z�t�(y�RS�ryn����\�U�ɥ�(���2�|F�&V��Q����&4Ӵ�8�㐮�ϖ9�r讯�bh�̖�ΰ*���(�N��r�L�܅�+	2ǲ�|T��J����1�|����+ۛ��[�4]��R'�����n��	2.w��љ����Qm��n��?�9h{w���,`ΊOUO'����q���ȭ�T]D�֙�����(��9��N0�.Í��`�j�~�Tj\��ѯ��7Y��(DkL��f� [���G�]�%���}�$KM����a���(�/?h������tg��X��ASp��2P�lK�d,:�H�v��OX�C�-Wn�ڰW���8�O��=���=������x 6l����'�w9镇�\ ��L�f}A�k�ldG=��a_�*�+�NU���9��B+�X\Yu1��UՓ"�������������nk�T�s��3z�4B����}�H21��)	^����Se�X��a\�3��1aZE$<��U��| ��~�Q��A���IT�=I�Dm/;$K.͈yU*ɢa���m��Su��k��tjb�z6Ŕ��C�]D�KM����=�J��#����E4��g��l����eFfzߏH87��������4��I��.��4��Z��	��{	%퉠�6%��)�z��Zs�2ڏ��Ŝc?ao0�6^�j���Z8m�@�[Z��s\�H���ƚ�ՙ�ڄSta8Xz�#�	l��Gm�k]�K��\_7�v8�1.M�?C�v�QG�^�/!.Ϋ?^�].A/�u899��жTYZHٲ�mU�S�§�t�Uc�G����)��QzH�0T�k�G
�2ȕ�\4>2� PD��L񍎔+*�V�;8�څQ�3�k�6V������f��TU������`���z��^�XE���z2�#�)Q��B!��qd���d��A��\�w��]d�Jt�U���C�8��$k�,QTD W���dZD*�<�Au����
�('���Y@_J[f؍CYps}^ܳ�<w����9mC��
�%�j��קU��'6E����~�r(�F�67e_4�z��&�n��.y��
gQ����+"�]X�@D�^ڄ1q����9�Q���a�w��y�'ޔTR��FEb�ȋ9�)�rP����p��E��;Q����ˁ+/���I�L�c�9������ٵ��YtJT�Ζ��`ySN���d75��������״9�G�1 �����iU��� ���v$�K����n9���@��a��N�Oe�������CR�<h��5��D�Lɧ&����A�?c�:J�Oq���S) }'j�����PZ�LH�����垌4ѐ����Y���^��^�՘m�Yٽ�V$���}㘞�=���Vp�!=Erߏ٭=�^�LźF���3����]oR������i�f�?|-O#�޾�u��'��1?z��c.�&fQ����O�`�֒>YK�ڬ��{��ta�m�H0r��j�u��>f������xzlQ׬�/`�~��2��j�w�����{�K�{Y:Ǐ�Ӄ��i�4�>C�	�����?���ś��G�mPJ���Se�|�g���{��W�C�t�fo+3V�ɯ���
��lW��M�Mhzp6���:�O2���Sӿ�y����M�a٠إZ�L���������WIy�(���Jqt�K���I��}��.��y:�=u��0�US�O͔���M��B����X�^h����hUS����UxCd5Ef^ӽ�l��Ym"�i���h������Vs�v��K59�{�mZ���Թ�ß��R�/� rD�����i� ��g-s��������jы@�_-�Z�8i	�lf�B1��Y
Q���1����x���>R;Α%�f�
݆���dhv��ũ9>���@� ;�W�J,��,e�Ө���T5"?���=�D�����%����%�	�O^�M�#z�tߣ��A���%�^sܑ	!"����=��cO��zI�}5\S5����u�7L?�aQ1�$P.�����a�n��,���U^
4�"��(M@L�N"����4��8!5��j�N�?���C�8�A�����&�5`�4��X�>|Dp��,��8�d%|q�薓~2�4Q>,�n���j2�cA�H���a�]ԗ�X��W��;��ǖ��7���^#�S%�2U��^vX�1�+��Xl4�iC�Y>���Q��ד^u�^��SG	����n��P�Ŵ�!R��#;����*P�0��l��3�/o�4�%�N"�K��}!{�(�۬�된��u)�@����y�����sa�Wy���I8U�ދ�iY�P�O�;��4�r�̓���"N�7X����I>�Q?��(�b;�������g��W>6���g����)J��mxv�� ��#Ù���qX^Ș����H��*b�J�k�<�w6�:%{��7����/tr-�C�/���Kx���ܑ8�xL9!	g��-�+{f�� EvW!ɣA���MڋDz��`��4`��������n��7"�4��	����7�.�
�;d$���*&j�`�T;��� 
7Na�뾭����,����	��3����qJ��h�r�צz36�ɜ�K��i�n�{�~?���ė��X3LJ����S]�����3��S�7 H
��>l���'��<��`,<��x\�	�E&�ֱA����Q���iny�O�Q599�g�v$	�AI��G�`�;���υ{w�h����?A��R46��ĕ����"�R�Ht���Q�遽�,ѣ�A<i̵? #���*#���q��8E���cc��9�Z	���c[�;��Cu3N.,��9�S(�F���F�KX��0W\o�RM>�F\�Ԝ���0�����m����g�k�K�E�?��}x��u-7�����+�����������û7����w��������<�������^��?m�?��螿��߽{�������g(�<�ψ��_<K�s1�N*X?M�@�hBKD���6g��g�@�މSy�%���{�ye��hy��(����g�rğ�����m5���� ��̏���R����a��f��,�  <����L�s�V{T���|$#�0/lC*��ǚK������;wB��S~-e�;$�H��e�@��)1l��OM4�.$m}.=h��8��ޣ)��!�Z���"^u�!�}	�.�pR�:H�ڌ��Øߪ' \�N�p�i<*g^�29;D'B;">����S�"K�P>�8�/�B;���sT7LJq��kHa��@ۃ�*�o0\[��=�_٧;naI6Y�%��q��1 ��C%�=':Ȳ����Ɩ�-l��6��۱��7�ȁ⨖X��\/,2uȬ�#�N���<2����w��m��E,*�¾��둎1ץ���y��渋�����3��XâE+�5t��#�Oô3�0շ�)܀�6�ǎo�~�����,��g$���*�N�rp<���+��ė4ч!H���l����!��Śf?��:Gk����c'
!�j�i�#�u����Dq��jz�F��2�Ӊn47�������Ys��7��-jK<���cB#N�~8Ε¿vTi wB�78�K�bc��+��)&�h�'X	�=>�!0.;�=.�Q&��䖲v�2�m�P�d�lG�W1��8M�oiu���nG=�D�Z��2��&�gh�w�Vu|\�]G�	.ݮ$q��I�����$8F��F^	D��61���gjAi|3��jJi���+0��Ng����v��O����M�/Ұ��M<B�d���#u|m�'����XRlp���ʞ��f��)S~%��/5��Y�29�3�}Ύv�yҙ�t.?�VW�C4��{2�w�rԎ��\�*�=-Ư��&wP���S�l.�e	E߄n���.�k"e��������暝4kɥ�Ιş��fޑ�'4�K��MZxr�$k���F7qF��ǂ z6�@�M��I�^"S�5�YH�����@���d��A-	S5{7���'��HF~J���/3؎f��(B�D�S� m��j �/�K5sb�7_��-}գ���2��t�R�EU]-�I#��G��D��pή8�Pc
�_ܵm!�x�L���l<�4�SY�H��\)��)}>��e��(I\v�2mǤ(EW�XDL�f�r��=��BT�2UO?w�F�K�*Ge1<�k� �jb\��p��a�Ŗ�[RĶ�>r��Ni��ǝ�P#&�;�?�F}T��:^{(�����.��L�f�/��x/��v��
�xA��:���.�@����N�@�z���Q��[��5L\���qd��_�؇>�q��h��\m�+߈��#�˛���UiΑ/�?M���g� V6�)����<A$�4���pIf�x[�����+N9��sƭ���O�i�
H���p�`��@���yΧ�pQ�ff�H�R���O5[@��K���O���7��S�U�܅WX���Ֆ��ĕYg7і��|��[r�l�	�AӄT���&h+p/�!6�\���c�̵jW�K�&i"���+��!��G�v̶����.D�I��:��l�@\�g(��c��SyR5X��$�]�<i��4f��1Xx�1�	Kd�!�]}ԅ{��ţ:2H���m���T�D��� �ׅ7rl�_�:��(a�b�5V�����(/�5Q^l5Q^l7}�i��<����$H�a�=T�iyr�a��	�uaóڏ���s@5���o�ً�%P��I�(h.����s���Cٟ���Ң�K}�ÞE``uLt 2DR�%��x�:k�R�i�h%�'�ܡ�O�
�/����}���GH��<Ŕ���M�Ы'x��S�y��P�{OԌv,�m�m{��K~�k��{�7�U�;�Īb��^�3�<ṭ�������������/��P���G��1�bu����k,olMcj07ƌ�(d�,��������~y�r��`gR����������q5����Xe_�k튃�K��m��:n�o�%��Ƀ�7���_�y�~��������hKJG'����nyd����"7�Β�f���e�hG-��9"6�o���W'8���q���fߏ�Ӥ�[dKH4�A�$���G�h%�~�¬�F°:��%�(Y�AM�ڐ�ҭc_z�X����	�1�������1��#�7��nY�j%��l"Ե�KY�=�m��D��v{�� �	�,kK��(F�@w|��N 4�Yu?�̜
b��""����p���g�%1�����J-��X_��}�7��ˆ�׉{A��:����%JC<:JQl������m��抉�q���b������GH��ac�)6����dzVwcc�<2���3�5�޳}x��J#�w��uM�O7�V�W�"U2��8�ï�.^\���_�Y(�^	��n(���=��/s�[�w��c\jt�e\aϤ�+�$���$�M��Bن �]��RA$�W��[H
���A���&�&Djd�|����/Q7g����ǻK�XX�9�[_�n�נ�$q�t�6ID����?5!��-�a�)�����u ŷ��@��c%��O�`��nt7b��C������93}�����^3���?4��MF^�MOL�И)^�mf�l�!�H��A)���?��i�#���x�Y���C$j&u�}���G���`�t��*P24�@}{��U�+�ٓ���� ��$������⽻|T��aM�Y��Gu�I��(x၈�\��q�W:űu�^b�n�[�yW���~	�����z�I ���yk	 z�Q��(��NM��Ƀ��o\�,��4������_�� 5-����0�����}t����������e����﮷�>�����F��?y������/��_��?�����W�o����K��Rp˒ 0~qaCb>��V��~I�1!�S�)�!��Yǥ��:�Q����m�,J�Fb���E=3%/��z6�/꠮�A2n����#W/��F�3^-e��~
C � �W���?�G�&� �1�-��HD���8v>@�o9�u�C��ZS�F��,`� .��ί�F�\�� ����8�ւg]�钌M$��e �M�@t�|��@��|��x��t6��e��i~VV��l���Z��b�ž��W�sk�������ÿ�pI��c�^.ܾ%���Уa����{�1�e��X]��a���ME`gwU �:���y��,�]�0atL���f�i���p����>�؀�1�Ig+$�H��#f����<�'''���Py�%Y��
�z�ocbDA����ɇ�~IH������uL�b�1u�Ò�-��G�n\�&#\Y}��7ߏ��k��, �R�m%�Fd�]UK���-��q`��ӄ��+k�[c>���d�'�Al&����*i��I���ihN��jၰ|���z�e�� ���mgN���lѠ���-��GM�?6柳Lm�c?{�����K�d�V���TS9~�M0�����cu��j�ݻ���4�e���c�>zp�x�]��s�\x�5�<���s�r�ɐWbm�s��
::x���l�,�\�-���ǋ/�y����ႀ3_���yQ�ǧ�΍CF���i������h\�-��m/TttZ�핤����*��\���D�g�'u��H�>�Mbrւ���9���Y>*�I����9��j����aXuh ::�Q8�;��sQ�(G�JzЯ0%g����F���\�u�&�Xl�"J�3�s�O�Epb�D�6��uѸt�6,��ۛ >�f��qQ��l���-u�e�`���HF�� 8�kw2��F�-���5�`��*!��H�=�㣅;�����6��2�K�y����!��_�iX���rd���Z�:�K��4W[��$��A@!HU�t!26��tʁ�����A���0xlܸ�m�⓵� �5,HZh�ԥ�o�
vӁ�����^^)}̔��Г���������rfc(믑B@��`��"�y�m�]���]��5،��a��Z�d�	�!EΪFI]��t����2�έuԊ>�i�ay��]�rxQ�Ώzb/��4��9�\QyGMa����_����n|dh ���*t�3j��z�2���l&�oes�Ba|e�&�����D�����Jf�Ƿq���Ϙw}���b�nGc%�Y�ՠ�,ƿ�ۂ�@e�� �����9�7A7��;��[�gKQ� rj%C��ܰA3�����X�T:mTV�Oj���39Q)���r�v�����V������
{O��<q�O��0��}�IL-���,��=��`�;�A׃��;�Y�U2d&~�%^enZ�L�Z��,���7��[�a�c�܀ng�a{�b��wy|�5L���.?o��.ǆUf&�y�a���(κ��p��l�cO��e��m��nm5�<.(��f�[�љ����q���Y������ߨ��lp�jc��d�/i��pk�AX�E�!v����9w.��M�8�#��;��y�H.-&l�u��
��O�su����N cF��s�qoh�α!��Oo�w�����W�,�-�Q��U��O��Rp����r�4I��ҿ��+��$P~6�T
6���w�� ���d�z��v~�um,�"�[1S�4.{X����p4��)�j�tG`�����%
̖�{K��6���a?.�e�K���b͝ �Or�p�uU-X�5�r�+�/�OM��!�*�VF�|n���[�]����3��{�]���j`յ�`�v� aK$��/�$���}<�K�^�;�k^�$R��0n,�`�7{���� ���&)s4u����� ���JT�C��?b�F,��S+6Њp�Z	0.���,����}p�v(JJ��'|A����C��15~�KH1oq�;��\�ť��4�8b��r��]���y���J׀���Ǧ��>`q�ƥ�2AK]�[y9��j8:��Z ��d��+��Ҵ�/��!D�9cX	s�������y�l��![�)�>��T���iR�5��^!��>��z�Ƹ���4�6�5�/e���b(#.��>Y��,4w ����a�7�Kzb �'���j�L�܄M�*���Mп�""��³�����I$v���6o� jB����?���6���}���4W�f��>���^$ԧ�����xW�4��;����oe�7�7^N���\�@QG�k���7�PK�MAG\8�T�ʚ�皹ok{�S�T�<��&��/.�M�l���}C���	O��0"���>��Ff�o����M�L�ӿ_�·�!㫋=_1k�+�����'.�R�����b~���b_c���i�QV����x顢����DȜ�n�y��w�{ۤ���߾��	��gy�˔��,6Qȴ��˰��W#��a-�:�:�Eɯxk��xM�����i����&��YH���>�6}\n�'Yi����q���S���h���R���]{�d������uH��>*y��T+'�q�b�g����l�<5H�PDE>=���4 ����[��#^�Ya�l�r�cFa�q|Db88��vDm��~yo�jk�F�l��"�S-��Z
l�j�㾕 ��F�����3���G$C�K�(Zu�^�f0r��P��X�ż~�2�8�D�
4�	5P��]kA����=wB��B�2�"]��g�4�ڃ��a��f������{2���BH��tX3�@���H�6�_��)��S�N�RMm����6�vW86Ϻ-�4��{��ؿ,ؠZใrg�-9pF��n���S-��������wd-�;�{VX��	Lqf�q�� dэ�V��U��I*����`fLGצN�/�9�����c�v����
9)�ٝ�(P�qaf�
���&>�����]���a�
��=���\�����׀���}�����޻��^�_�{�o�|�����w����������H��on����K�C)�e�����k�^
ok.��Q�.�15�E;K����= "(��\6��<�ڨ{/2�-�~�YȾ�ቱ��fT�i���� �nxnq@��(�׆�1�n�ݮ���>�
�d)��C�s/h�g�t@p�P�f�s���:\���SF�8��wl�o��ɂ���U5�U_m�#`=E*(᳋|��R8�?���i5�w����C׆흆Nռ�>{��!^��؇�
Fwt��p7�_�Q��s�Io\�����v�ep�eWP���VU��0p9���B<��.��|}Ǣ�k���ü���Z\ay��~�b������ 'W��G"�&���x�̱�1 �I)
	�R0������&�]hw�X�����nh����+`23|�4���B��}1G�驾p�u������\M���|�{`/\m@&aM؞�����	{���	7%ɒ�����:�n�H�Xk�z�P�:G�;,��.x�i�T#���*=on��	����U����4����V2��N<��c�|d����&��q�u$��<�Sg�L�\Ȋ8��,C�����FݤYޗݓBX3��$�a"�������PGeJ��C�c/&�u�⽠r���M���Af1���c}�o�dw���y��[TH�8�� 5f_�ލYWB�X�b�7�F޳�Ky,�d�L@�`��H�s��5ajz$6f�nX���͙տ���ܮ�E��a��L�ʰu��Q�(����@ǳ�t���يy�;Ӝg̨1#ћ�������y|�T3,4sr09�ʺӎN�-!�R�����p~v��jw_�ۀQ`�H(�"�G�S95�����[;zV|���/h�]V�w�:��9�&�#��{�o�J������2	��6����R�To][o�{]�|�M�V�i�;�AHw��� ����i��	6��uM�i��l��i,t:�������8ݽ;^QtY�tΕ6��5�?�H;?��^~�KE�dx�u;%>b1����l;k�쩒�Hp	X67�|>:[�Jx�K�IHf�d����ўe���M��Ef�&˂�CkG����Av �N
�%��W֎�Mb�]j[���6��� ��T�1���Ei��/�6�r,*�l���a�Ik@a�0��i 6��W���#���k�UNG_{��U¯C��ϗ�^w��@/W�]�ZK^
|��\|5\v_z�r�l�4��i�[��]�BSz���CxtOE\;x7���$m=�&���f��=�g�O���@M���j�4�ƇZ�ٳ�Q8.��J�,���6M��߭g@MG,ڗ@Ms;�'��e���'�:ӓ0E��0�B]u�lBe�l�4`�0�)�v��~-l��s4	`�^�����d{�?8&����3>xa���C���o�TϠ{zW���ω`��h� ��Q t�	/�ۀ��V��W�	ο��t���s�;승�G*��N'Z���
��,S`֗ �'��Ӱ�?^��lsA��:@��"�bXk��N�5�{�"n�d��t��:P�L��K�o_�i�es��P�<|u��B�w�v?׫�X��؁��C^$Q2��c�g'$a���m�[t�->p����݀�8��婡ا���jn���/4�;l=���M�󗮥�"��O�/;���Ɲ{�>|;�����/�x� Ω=��:�kwph��+�ᵫ`��r��/��H\>�u�eּ��\�o�X��8���Y4��[e��:��N �M�i��&��[�������n�7���Ę��~��U���㕵�e?s�ǧM�獦�Ϛ э��?5}|��~������^��u��Ϛ��[���������b�;�΋�TqL�8{
�>�Lc\Lg��҄�U�i�b������~�1���7{ϱI贽SH�B�V��D�-�f�+FT�7p ����uL�C��_�x�b�`��l��Rt4�j����Z�>q�kn9��*�_�;V�mԹ��Z���Sc�\���gDxoO�H�wl���O���C�����8	_� �0P�4D��|����:����SxW��mo�<W�o�ٖd�z��8�<��P3l>�h?�3���S�B�OSt3q�p���E�8��Q�y��p�����L�~�ģ-�:e�P�R�UMi�ށ�f8R���Ʊ��~zޮC���8~MR�=�����B8d3����
G�-�v�����M�UW���gV��+���m�ۃu� ,���g$��nsa�K��
��&�!pLDtb�ynɢm3:z����p�&�丫�G1�aJ7_�����߻w��w-7��?��l���������:���o�=y�����w�ׄ�����?����?�����������h�oF���}UL S#�_1�]�39f	�-Bw'�D��"@|���7d7d�oY@�n��1@���hb�,~�2����K����cH�MT"���	`������;W�$@q��d.�
��e"�������	���BJ��� MV|�<r�~_d�A�6Fр�MK�B;��	X��~i=(>��@�-�+3�W�L��]�_��@�W#:�|�W�v0�7��D���4R��:��:��:���@n^����NuY�y8L�>�����5� �몙"=�,/�r"��l F�MR}5��p�����Ư�m�%̸m\>.zb��;�}��'�#��(��®�O�=���Lٿ �B��F���`��Ͽм�~�e��.�����h��@�0������*(�ziކ`מN�Ӵ���A�C���4r�\�E���Ah3�:�U\	��4�O�w�)����u)�9f��{H=!��q>�����P���	}E$��tHS������i�w�!�z�bS���gPJ�̟�&�|ʝJ)!r��+!�]5��(�w�0!�?�D�(^ׄ��+$��D���J=�˸������P��B$�$:
ټ?'���L�"�;�;E�`�ht-������dF���[��d�)�3+b��?�o���C��5$�.��j*�E��3_49Ɗ���_��k����9DѷM�#���L�sЄ��ur�&��������:ڨ�ҳ;2�A{Iv���/��{���o��>��c�_��#�0g�Hw�+Rrįz����]���9�_��#n�i:��##����;"/ 7�777_���E� �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  