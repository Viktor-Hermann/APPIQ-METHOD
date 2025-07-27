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
� �[�h �_oI�/6��a���9�{�U�V�K3�V�R��(qHJݳ�;Y���QUeuf)�Z����a?�cq�����_�Q��_}�Eĉ��"�����fag[̌��8q�ĉ��N�4=�&���񷺺zk+�������o���������������dumcs}������ͫYZBW.���䳦rPl0X�%������_�7��/��/~q������׉���/�+��:��;����߬ɝ��#�'��_��uP�߸���W��@�Q֝��E6I'�����������[�����#����;L_����\yr������������H^��΄�����XMƳ|�=X���qoc�W����8?�����'O���~��r��:���nl�>�����x�������w������*=���Jj�/�K�����U��^�q�������[����k���3_�2���qq����t���o =�mn����u���[���n����OֿS߃�v������뛷�߇�E���ͭ��͍�[��'����w�����������y����A~�Ng�,F�vr@,��Eޛ%�x�\�feUL���8��E�T��U�2���b��|�YJ���Pu�0g%S)?��I5�zy:���OΓ|�<�g3x�N��Q�B�g�,���y/ņ�.4�[f�,��(�2f�
K=��Y���2�'�|�'��"�1pz�A����Q:����f����2�n����ɼ�>e8�<��LS���`Ge���W��|�'�$��2�&}��g�64>���M�#I:��i����U�*��Հ)}W"�:�P����j^f4>��,�^�N􈤝~у��7��с�]Uy�JY����@Y.�Og����8�w^���fxjr:�s��Q>���a�{5ʫY�^�}�E�p����|R�J�3���{��|1�ض����a��}�yL�#5��Qћ�Z�j�	�l�&���xϰ��A�b���+f�Y^e�z�y���o��ܽ�]�<&�ҽ�{���x��Z�*�C̵,��$���S�	�:e��ʻ��Y1��� �e���Y���y��k�����Q:���� +�s	��,�$U���?]�ҙ�����8�Ca�.�ƶ�f���4n��5����Ù�L�e���"u�Frd��>R�ʎj��}��s�6hH@?�'��|��d���c��MU�3��qZ��6�;&\%�`�_O�	M*H���]R]ACe1��DT������=�BB�
���r����>f���� �IE7$��V����`E�<��`s���3�a�E`s�m5�g�Z�_-��))?���㽫��r�(��a�����L��,V�
L>�Oˮ�|{w����"���e�֊��px@L ���E��8��F˺ =�8I�?�"+��s=��űv p��A:u+cV؝W����t2�|�T�^�$�-��\泡���V��K7H�d�ɥ��;��
بQ膛?Q�l�%1�������$r.u���IZ�m����+�ցN,��=�_�N��#
P�����5�;ǆ|���t���{N�8i�+�����]C�siP�	��-�Iz����6R��c�!+?í�����7�gYہ�0��L4���
""�ö'¾����� {އ��P|DdE:�X�,)���I�}�9��G�B��9�8zE{�.�$v�
������@["Q� �@9��@1���k�"������ڬ�]As2���!�%�s��p��qbz^������/�Ǥy�m	F��.��U�`��QW��Gw����y���EA�;:/?a�ܡ�����%�mj�g��ݙ���(C�$�'gEZ�a��������s�����a^��Y	�z�Kͤ�m���E�N�W�a2Y��Fw�bƸD}|�X�`<�(vԢ�ޞ�g�e�Ø��WQ��-?�&@�W��j>�匫e��X��:+.pb�,��=�}�����3��~'yZ���Zc!�,t����Pf��pI6YhD** gq8j+���K��5o�a)�7f��2����p��z�D ��jo����l�e>[����P��g��3!���?O���F� ��|}��r�D:A�����.��y63���_`g�f�x�z�]�  �,���c�&��a��ge
��@U��=9d-wT����㷇�j�L��Z�2�3�0�"��mS�ʫ@��0#ԝ���/P^�qH�auH���)��sz�DS����y���珑�0�y/��@���"�{�?�s=�`GΧ(�6$��,E�o�<�jjLK�~����Gzd�g�������?�{��Df��a�-���mԕ�x�Zq]��	t��##�s��@�v�Ry�V�e��s�p�t�3'S��R�v�r�bs����k�T�"JC��O�6lZL�����v܌���vaow�Ws�٫p�tŬv����x�C�ηg��,lBޡ�4�paa��ݲ���Q���Ռ��I��+�b'8��Ov|��3��-W���W5{5�5Z��:Ja�����|�zۯ�=�8lM�T�X]׋kU
���<Lp����6�F��A��f���4B�`�jIre�����a��H�A�n�"��,ـ��a"�}U_HVj�'#T�]�h}�o�ud�+ㅕ��п �2���ΤKKʣ�T��]\��"J�-7�Pd�V,K����b�0-�ot��4z�����)��l�[�W�&�W��Ʊ}nJ�X����w���6�Ԥ��$md��j�I������H�锔|�7c�@m�eJ�"���i�OF��QX��7�c�yߵ��C��Yz�O�6ܮ�턺ZqR{�a"��Q�-v)!���pe�I�L.�T_���O��(������0Ń�|��_�fM�J�b����л�
�
����lN��6�4[���|�
k� �_�1�v�;BR"��rZT���hN7&�$���ݻ'i�+u�
�8�}嶆-U��C%��6a��ϩ&��_�y+K�O�+s:U���9QD��������I`{#��1�{rPD��{�[�BF��	ṱ u.���| h'��^vV�tQ��1tce�VH�~�L��ę�`�?�J4/��	�&�I��Yfr���ǃ
��%��lL#y,�S<��#+�mG�cT@V���A��CF͚��И�J��Q�)KJ���R>8brn|��S�ZZ(�Gżʫ�U�UA�d�M�������f�Tf+�8yVL:װ��I x�Xӗo,2�p��� �u�D}n'�)� q�ȳی@,Z!lp⡌���^y55���?t�2�A>̊^1��<�)�R�&i�J��a�<:<j'���;�4���Ntɒ\���k49a��|�8�����2��x��������*^T�y�;7�u#Cl�Qk������t��>lq��!�u��HB�(̅jWP	���e��V��# ��f�V�k������Uc��W�w94x�۩aU�x\�k�iT'
����I~a�r���8�1ծ�/x���������"�Q�2�m#韒���G[;�J��t"{]j�0o\��I-���)����k�g`�����:D���o�P�G�6���+��e�۳��7�ś�Χ���t4�s�9�M5$g���o��H�d�K�i����䤐Z�Z��g�_���+
+-���+��M'xc�S
���c'Ԟ�%no��1��>-v�������_Y���d�^w9P���A����5�S�Y���;xm'G{�'+O�t:����@m'Gc�F� V�7��-y��9nw*P4�6�5E�����z1�A��cۊ=�����빽�=#��1�H����oe�M��xӈݴU��$�əH7t1M@?��8V5q7M��Ϫ�v��/'D�7���-�]�h����>F��dַ_@{�`�D.&��
����r���}�g����9��캨+I��5M�#���9F:_���6Q4�2��--���B�'i�Хd�+`e�Ʀ�:a�1�9H����8�f&��*�{�r3~ڛ��V:��x��VsFƚ,�����cF[�+����/2��-��M����H�������,�d$}�X�J�D�E�]b}'5��o�%D4����<Z��S!�g��|"#��kx8c/A� ���T�ֺo�'Y�����3kx�&>��c��zї��y������9����Y�8[�sN4D[ޔn,���T�]Y�k�Z"���9_�'7H:�Ou���v�9�>���M�j�td%@��|�Em�}�E@�`�~ R�@�>n������d�_fW���UM2��8�=8[a�xv0�}8�pQzV�Uc<�-lrn,r3��t��f�� �LZ��K�-���"]�Э���.,���.���%nb�x�N�p���33��>�$���w������դ�d�+�\x�ܿ3�Ⴚ>�Mz�8��`j�.����i����_����,��=��������������M�?�x������[�n��>�/�wosum���m��O����������?����������C�j��t������\����,g���?r�����r��~5�k+i�8D)0g�)�?f�Y�앎]��;��yV��྅��(�ƒ׆�9{�!�{G��8�Eb�Lh�A��_����󳌉~i�<�|n��5D�U.��Uven�sc�3}:��:!���Φ.�j�?��ͺ���eaY6��b�<�� >�F�J���jG��f��k�Z)�tAK�H6���l����\���ʴ���l��&��Xٝ��Q��x<�f_�(/��R��ɰ�E�$�IQ�^ac7�[sj����Yo�,�tka�%��A��U����ko��~�L-XR�܃b�T�{Qf�QzC.�L��K�znu��^�/I�ޞ��BCZ���$��%m��~�|� Ia���Iy�Y.�
>�I!}�ܘ�a��U=���Q����@�am�/"ۅ��JM=d�H�8�����l<]]pH�P�~�-�چFAhioD�Y�l��S���l�C`�5w��W�6�+i���ٍ6�E[3G�E�3�K_�	�op��B:cNm�|��ܖ�&)�W�s���6������f�H�+Y���L��-}���cZH6XA.�] fh�F	4���ȟ*��Î���]L���Ó�e��/�7��|t�_Qp9���0�/Za�x{��;�+x>L+~� `M_��A�j�G�Ғ=ŉd�WT���[8�a#T�������t��|���#67q�"osc���W�5�b����1鬢��?t�W�niE�v>�Ԏ��ɯ�3�K��=4D�qt��1��%�ֲ��d������Gwϐ�aG�녙*�zb�>�ݵ�Q'�K�c�a?^A�/��uЏ:�n���\3����<�2!va�m8ݿ���8s����k�x��ڇ��k���JN�,�(M�/�p�LK�����lKnJ��� ��#�Z�a��ޖ�_�a�m'Tk��q�����龉�uL[9�"�w�����t#&�.)Za���LZ9��s�@�����^���'WӬS���Ū�i�R��F��I���i���������>�<�����:�V3�x���g
þ|y�;��,�n�ZzB���N����3����w��K�NQ^<	��R��Q�N�;
��#�hZ�v5f��f3>�bvo�\�]�g�+�m`���c��K��2���V�E*�|��n��WzJԖ�y,���,�*:it�D.���@��N�"{]f�d�������F�.�H�u����B~���Ѭ�;߰v�H��g��zzo�CG���8�}R�$�S��|�C��i�ꆝgE9.��2[I"?�ڸ� ��9��H�����.�I�M���������:@���>�U=@�;�n�W��*�܋���nU��p\֊W�k�q-�[��$�����H��פ���͊�M�a��������_G�3.f�r3R�\bA;����1;���H=3���r�9^��˓�ZQt������Q8��c�Wj/�VZ0Đ	��]��n*N�%��� }��<��t�ZHTS+S(�/	0�taE�Iy��*>V�d�۹&L%��ntۆ}�AUe�C�)�/��]܋}UH�p��z�1G�8_�`q7ŭ�ω���t�y���"�$�?�BP�b�{��m<�w���ë�fQ|�LSj���:W1U�|	N�B�B9��S�%�w���h�5�U�F>E?���'�|��*;��u���h`����jߨ^�@g��Ui9:j���H�>�g������9�-=���,�L�B�-��g�o@tV.w#���zT��u�n7s�&ވ5�8�z��%Z��L�)�l6����Z�x����PhOI܇T �M�#�AL(�[��a�~�5V/��w�]��Fr�A���Y<��|ؗ���������M�l۪߳���Qly~!uF{_~'q���FP��5�e���M����n�:&��k�ߍf{Ų��e�m�J�i7�׌��`@� لV#1ힲ��|k��1���7��^T��p2H{�P�[�9���2����3���{�`�������l�����GRcGr��
�y͟��Q:�a7�ye�N���^�Ȁ(�"u�Ӹ���m���Ѩ���C���XIAV���l���6-yt�{;�K����[P�E�������P�dr�3��fy��&���A	[&v��E�72��٬� ��|Q����ɫ���.��p�3������6���nnP�X��X�,��y�4�gd|1A2�h#�f��i�(���n���dK��~� ��`�3���OU2j"��eX��8%t�&��3�;!L���2�\�D�<	.�� ���'�$c�h'�+/҉"��I����ec��lf=��8PD���p_*��)^��;�Bay��C�
�����fWH��������ġ�.���t?%q]|C�I/mu�xD��xб[�%����r�Y�|a��K}4WY�C�\����||�M�k<�C�����_�m��}�߭��������cʁk����Z��������h����������?�����>v��������z��[�����np8@e͹_� ��un��z&e�#�=v�Y`�\q�c:�J��w>0�q�PiK���R7Qy��_?���IS2*�A���R��ڑ�ג���7����Xʜ����-\W�ýRߥ?�k\�~���y�)�6`��3	�U.��D&X�Ω����1�[Z�K1.�����S�	ӯ 9��"�i����s�8��*���k^%�ՠ�P�k��c.��F��t�A�X�N��m'�Yơ��0��]Ć�-�Վ-;�i��7��j�⑖�{�R��S9�a���hj���Q�ֹ��|,ـ�1e"�.x&�z~��c�?����@�%-�C��vr��^!t�%=�b�U���-Fh�4�v�)�2�" G���nb�f@.��v�P�Q�	�L&�����X����N��ƹ>�0�W}>�֧#U����}�[����.i�n���{���6��F<��9�+���&�I�Zz�l i"�q��x/BɆ�f�c1 #ۉ��T^�pK0��~q����5:��D�_5���-���$#��Qě߮���m��m��m�7 �d-3$�bQGד��{PXe����K�ò��W"/�3ݼk8�7����� y��b�K)S��RX�����INI �~�����/eo$���A� zP�Qp�P�	�/�t֖���]����"!��f�y��U��"��E4EOS���~�w�S���/���нh!v�n��2��2f�{���MI,�7z��]1g��_͢�x��W�|jV[��y�S�`반΁d��������SQcZ�u�
Z\B���\aJ5p�t�j]-S~m����q={X}�UC{?1�tw�1h��L�y_����VV���8O7vT��>�Jk9y$����S�u�Bu��H�$Q�d���λ��;(z�v��1;(���r9�U6{1m�O$A��A�Rk�S)�>�j��Cl+�ն�v���˪+8�;հ��P��&|5w��P���,�4z���#&OJ��`vJb[y0 �5�7���'�A��2	��argZC/R�'����7f��$҃σqt�ñ���rqKw&�eV�Z��SPC�RO��7��	�|4���i>Sdvߊ4R��c�����v���tG��K������ў�NoD�S�?��z�|�F)�|*(F�6���i���g�g>��x$���v	�$tp��yw�}�*V�����w��x?��x�i�5�>*T������
]��7dw�:������#�A�4��.9����2lI�ܗ�ɑ?�o���)�x�-y�Xlg8���	e�N�����Lw�s]6(�mT<�e�C�/;�G}��'�Y�e���7\f@�~��
IZ�y��]�$m�7s	|����|�Bl�'�!��;�D�z~_Ee������~���B����yY�PN��F'��&�ά��$WC�8c@o,Rk�Y���*#kc��fn��#b���i�4�v�Y FYl���v	<��,����ev���ݡ§g���;��?��l�<Cޔ騊��a!LP�D�	;Ny6�C������鈗�w��jn����Fͳ���;�1���ݨWQ���|b����֫�p���v�rA��"nU�=K��8�욊�O.�t#T��ɧ���\�eV;M��\#��]�/���=j����?B�]�Y�3���O�*w��10�K{Ö�F�7��܁~j&���Iv���cIK_Ν.9�П�����>��q��=v-�z��=�M�p�J��F�u��.>9B�E����Zo�ǵ�m�j��ny*�A]'�=Ev�b�^-�Y�(�j�
_��C��]о��W�S�;+&T�N#�)0#��|V��м�r��Sy��[w��kw���uu����F��nIߩ`�|"۷����ͥ �V\t�>eЀ�J��xk	)��V+g'�^Q�zF{�5��Ki�b�7f�?|c�}io;����<,@!�Ĵ���?�UT叼I�h�ph���-|����,S����>�MV>�N��!��cOw�|V<�N��lxժ����o���u�b�q�״	�\���K��K��R�4���LSIڬ������[3Q�`?�޺9z���Ҕ���S77�MUX�vx�W�>�X����|�����q��X��Y��)ou�p
�p.��+���U�"Sgԏ�r�9/PA�f�&�շD��V���3L��I�G٬x�DV�d����v�y���ZuI�-�]����OJg���2�!Q˒6��ѽ���k�O�v�i�]u�~M{'5؇�y�5V���t>��@��YoRǣ�X�;�PD7������C�;6b/`5�z�̳A۾�r3:������L�e�>���kx/	��,a��/�w������m;}�/���vk�[��1��|�l4f�*� 	SnM���3WjK�i�_H2`�%�0W<xXϨ���lJb�Te��aE��d��h��OA2��NA|���'���
C}�e��3$��������N��m��R]�O�}�$�����Q<IPn��M��R��٭̧�Ky
yp+ yJs�cR?�Zpyc�x"��$a�f�H�24*�f�ݪY1�������n-w��V�H�d";�"��CN�]�W�Q�m�l�N���Xj�����UuKkcuuշ��,��S�@*��]���6O�C�<�lU���_����f�i繃�u����f���ǽt�H��U��#��e�]v���HiF懽��m�<��(��φ�H��܂�Sb�03<��I�T2�3t��M�>����r����1jp�]�H=�1Bc�sϤn������ Lb�0<���lNո(��rYkRH��>���]��a^%��Ԝe&�p_ �
�)��!D�(�`~��.5���O���	GqE��fw1����p�/��7��X��}B'�r���%;k��O&�����g&;��}r�!����S��@�5q���rN�n_������}�d(R�}Ŕ��):������Ԉ��Lx��W��7<�%�[A_�Az5VL��:d���3�H%_I�#y���nS�G�&Q/Bf� ���Wܣ�M��X]���ǡ��]㊼�7�R9j�͵�@c�0�<��1J�J��O��{ٍҳ���d1T����\m�B�Z$	5�m�����Z�+8��h�z�����x΁����=M�d6�� ��J{�{�B2����C�k_2ى�'��o����T3A.t�:ٸ=eȯ,1lrT8܂"cz�x_������-/�^�Ċ5	�O�El����l!�������\ofUE�D��2c�l�{
S�&E�k�[��q��,�.����z6S����B���&�
ܰ�%������N�,�~�r�v�y5��ú[�#B����3,Os��ט2dYՎ1R�$��Y�L�q�`�C+ϴE�LG��3L��Ǖ����Z�18m�]�^(��h����UA�ah�X�W�^�:v����rU��K��N�.��ր��I:%�zV̞�G�f������p��6���	I�c?�:9�i�g#G�����V4�hԽ�Ի�E���0+�(������.Q�7]��hPWɃt籬���i��WhV���̩{ض7Irg�yj����H���z�qQ����7�4_$'a�dQ��Q=|����g����:-��<�C-�^t�ژT9��t�Mz��ԄoH�� ��;�HZ3I����N;��q��B�RLȫ>���t4�'seW�&�M?]9yz�"�q'�M�	�G Y�&_�0p�oWQ=�&6��Po�8�� �кO�s#H\"���BS���B�7D N�A����i4 ��|V��[�c�R����b������i#Ƃ�����C+QLA�TG���m�v�
��D܌h_���1������ozj6��+4�[������&�h5����.����;r�0�����H���;��Õ�����$C�w� �x�����$T�tta�u�,�r;G��{z�w��w��R����8CX��צ�M;�mV�p��VW���m��[��~���,`�M�W���g�t�sT3��0
Ε�ғ}^������'������m|�:m;��.:r�(L��L@4�b�vY�-�8d�!�mi��3_�H=V�Y�X�EY�H�bi�r�V�O�5I/�H�1�1��h��#b&�Vp�Zt�����
a�	��)h""%)C1�!�::�Z�å�)�eCNCdF
D������S:��q�f9���;�݈�t�9Ò鼄�P�w����=��vVL5� �Wz� �V����Z�v.�$\Ó$0�-�.�H�7>�O�vX@g��9�Q1CpZ��x�_��d};!۠O�A@� �[Ќs�e=�ѡaG�C@cf��]���=~���qo���i��q�ٜ|��N���&O=[O�G:ǳ�IF
��.B��L@����G��1���M��A��&�c�IAO|eu�ȇ�S���`�O�td�p�S��w{k%���W[�����IU��6+��VZ�Jl]�R�S�fc[�d�A�XE�a*� �dGK�@G*�8B��k�D��)�0V�v](��0:������z�n��DS��B��Y�C�D��8�U#����R�~�BG��H�p�
���7��^��Hc^���]�aH's�N��NI��L� �s �G�F�Yɹ��"1�Z�m��K<Q���w�Q�����j��O�2�3���*9��+��s^�tcĴxɈ�7��U�� �F#<���R%�YSx�Y7ýV`�[z�	Kj�Y�R@7�Zs�)؝w��CkT1[}��O5��Y@�6���:�B����m��L�G�ǼK�c�ә�n,mA�Ɔ0�woOj������_��OF�+�b����5�?�_��iQND �w�����y����n�?ֿ&��S\���V����z���-���m�F�?7~�~���Vu �������c��n�olm���Wo����>2,Є����C���:�|����l�A6h)�� �3����G�!���f�h��<���D�6ʮ�za��P�!���(�p(P��j���h�N��} ����iY4ݱ26W��A3���6&�o�pz�Z��uX�zrM��(�f=�\�i�p	k�Q(+RRe��رq�ڒ���%� �/���I:K�l-
sHJ�k�8S砓��2x��+�c�|��̭�"|M���2k���,n����:��瑔:R_����fs>E2�D`���e_�A��ڻ���_�f�%�S�q^�Y����B�T��JZh�jK�Cg{jk��r#�d^S��QA�vM�ٳCi�ܗhBa\r �Af����o�ݰ��G�ɏ��I,���frr�>�O�tVl��%�k��Jj8��F�//�8��Y��ƂX�v�[o�NNMc�! UR�H֡�ߪe� ��l|"�&��cK%]�v���������@��Ƹ�7��鼟S�w�d��I�Y� i�
�&�M�;X�MN�t��?�cĶ��ƼSMp����Ĉ���;^��X�0�i� �M��x-����������s��O���LG� PR��џ;�+�J���5I�?r.�T��۬�d��g�����?�[A�NN���m7H* ������?���f�B��]B?`Qaگ�Fd#P4���?��X��v�Βɞ(�`���";�S�p��v����^b�䓤bϗ�� U���͐�o�5�� 3q���['�G�8�S	G3 �M�ؗ�s��0]�xz�O�)�tW����Ik��!���2f'@Jr��
��L�;}�s���˃�u>	J�w'�\^���n�12�Լ��o��m�����ե��H�D�9J��zN1;�������a�Sv}{n"v>�:��h��T��|>Sxr��۬8R�6����3 �r��Ǟ1D�Ɲ x�s�'�	�Δ%]�޹ �1����զ��57�N��E���r
+߲��B���RJ���@J��<v���������2�MO��g2
8&V�6��ø1��
| 8;��B~�`v�,�e��ђ�]]��k�aܖC>
��$�}�h~�N��lg���G����k����+<�+!���,��Y��{�g�����bZV%XG~�ܹc�⩾(F�����?W_�b�V��������>��R��`XB���|ٕ�!?̀�m=�P���Ʃ[�F���U��G���n�~�A�����ͺ��	`|�=-	M����(��L�s_T�ƜC�,r�Rm@q<9�5	QW�荱�8���(`�}#����ĉ'd2&�o��AK!�A� �G���ǻ5���@ʖ�S��F�}�����"�xD	ԑ����*�9�O`4����y9���*��A�5�k��VPu��X"�e�b��,�����[��DbQ��b�;>D=����i��fOMS-�m�BR�,"��n�Hw�^�3a��i�u���D��ڪQ�1��=�_2��}�m���Ж��|�j	Njx��9��BkN�i�
'Xw73�+�~"p8���M�8hDc�V�F�SM�	n�d4�Ǩ�۽�GSJG�������/.�5j��}"�������-���|�2��߰�j�Y�]V��UP�>�=-SV�h
"g���0,����p�rV����떙�����[-`�6n��F�u��n}����k*	1�@r�	mVg��n�*����}�_h��*}�8���%Ylщ��A�TpD�(���i>&�����Y�${g�Oe2��O�aZV��R;�z�0���HQ�3�f}�{w��W��kl��1��ؓ��#Vm������V+��[�MJ#� �pH@3�M�O+�?�U3L[�����m��#y4�A�`�R�LLŌQ���Q�&癸2*������r�/��<Y'�Q�Q�����h'�C��O���<�s)6yC�$0�Wڿ1R���*H�]O�δ���Xa���)p�����d�
��]�{����p��ϲ)%*�q6%6�$8}h�	�/�\�Yw���2c���kd�AF�Bt�f�m��[�j�ߏ����{\��
b�>�7m�W�+���E�*{�~JQ�E�������xb�ډa|U��(b洅�a��i�$^�ѩtŰ7�ob39�����ھ�BS����]
�@ذR�HLU�/��Xiף+O�M��������� ��[)���۹�l����9K��5	u忽&�$~���u�qF�1���� ���~�,п)������D��#��H�/A��������)b��_�w�P~������������4�*���]YS��x����F�-/'�UZ�eF�ˊ�0�Wv�!��!�Dh<�9L	�	����Z���i؉ڝtN�z ����(k��w��2۠�r�4��E��O�\9���b�A,����X&��'�Ed~��i�������X����zb�	좽�P^�2gdH猕/a����)C�i+�t��Ҥ첔J���Ի�H,2��r��u�X���VF9x����aǮ�]`j�sD�e�Ǡa�Km���Yu#�}��DS�x��U+A
j�@ưRl`/�g3뀑���%j^y�e�U�������7�����xUE�v��=�R����T�C9�*I��'�^��������&��	�K������R���Gtp���Au��� ��.������s�"�\I�*�{1,1nއ6mC�N����Ԗ����~�������y������˔�ŋ�	�� ([o�RbK`֓���/���|q��!;z/��܎+���vٍaew�O�Y�x~�!�f��>)�h`�q�V���ڪ�z	M��v��<}j��ј�I�K�5"��AxZ�Z����
���'x�fLn>$.n3r(�9��;,�����A�.�[�	n~���s�N��5w9�;��n>�(^e܁���;;$��Vr�d�Jl��l����g�sY��<Na+�cp�+��b�l'�&3F��w<�����h&n�t�c8�{��.3��L	��~=����,}��d1(�ԝ�W��D����jE{�xKB�N�������Ⱦ͍��uU�a��}��گ�W��_��c��^���H�ݵ�L6�k���c�&1���H$�)��y<���{�E��|[���%��\�O���n ��Kn��;ò'�՛ud�}�����B޷���/�mk�f���������w]��ʻƀM�2�y������\�|�;i����;<IR^4���kҵZd��BJ�Ȁ����k2zr�^7���}�Iݳ���c�Q��	���#����e5(G�n�L����z��o�!�Nl7����#�%��~�ƹH8;���X�xD�:)�+�OC?oٿ�p+}c��kN��V�u#ꐜdfF/���f�2� ��CFe`���&���e���|"���o��$^kx�q�[��r̿C��q܉�'����F�3��L
D{)��
�:[)骘�!��!�9޲�o-�-aB :���j���0t��-�r$��5%�غТ������D�#�0���ơIR.���,�b��ūO��1v&��v����WA��}������
��5H�O�<�.++�`<W�t���gW��+�TkB�0X�(�zeZ麀0C�U��ج̷q�8Jv�k�ϟ���Ƣ���:Y�R��y�i��gM�p��Iv:���)هT��F3��kT�O�ӚW���$0A.G���h�Ǹk�'R�e�|�{��&-����ƶTT��	~C��解n��7�}�|ҷ�,��=�|)$&�X�u���#�V��@��V1���a��?V��]3��&w\0�8�b��޳ݣ���?v������:l���'�z���X��S�*M��B[��K ���uw����EM�yq��]���)�L�A��~�8�~l�.�xT>Ϩ1��Y��hM�3�3�c"�e��x~xV�~�@*yѲ������wۘ#�m�龘~��}.Mc ��185T���F�hj�3d���p�{Z��vLT����}om�������m����������Ɂk����vo���[����l�z�W[���n�_~�?կ��o\��q�����*����қ��3_���wO��w?*���������>��V��Y������Q� ����[���k��6���q�V�������v��������V��oln�����q�sN���'~Q^Y`9�|V2�z�{���%y8~ˍ|+)+�^���=��|E�:#���'���Җ�N��k����04�r�������"C�7���&��>V.SE�R�s�/��y�{I�l$w�؍�Q�1nk.s��g�;8�hԘb���[P)/m��`��x9��Ù.�O��1��I�^6M�����iVM߉�����h��իmj����}�U6��d����ji�+�]�����!Y��4Z��f	���`�A���i�]*[�G�Vr�2F[=,�K��zA���ʵ��tȹ��}�&X�V׷��;m�v�r`�4S���΀/1���$�1�ѐ�?��\܄�`�����D_��Z��j/!@��va�D�a���^J�������N5����BW/E6'n��^�}�!:I��ԟ��r�2W����"$��v�2����RӉw{�K��vvi� c��\�>�˥%����k)�<��F���rX���L�>��1��3-0�N�DEUul�#����nT�E���oӋ��#0�/����y�1��ַ)g�v��F�o�t��N�2�p���C׶H��ME��?۔��͟ɖ���%4�oe�Z�6Xj�J��٫�����n]�{sf�z�g��R��l`��h+��٦j)+t{�Iܐ�M�	ӝ\���VO���Lۄ��2#V��;�t��@!9���+},8���M.�p�����Q62|�;���&8w�3i��(�Pc��Q_�����Ҥ$�,��ycg�DQPv�s���t@H�\8�}Q����~p"	�m�b�<�r-c/���a��t>�ؽ������,��0n}[�����(X[���Z&{d��m�2�+�������R�L�_���#U\j�.r,0R������?�_|,�����]��?$��K���	��->6$�	�x����X��	b��sZ��	Q2,�2y�VNr]:�D@�&ǁmd\t� j��M�#�25J�:02���ec��i�'/�����gc�zvc�V2�=[�$M���%���@	�����֐sF��9�l)��鋎�b=PQ��K�/#�%��i�6�������:u�@q�2X#yQv]D����2�s�tl�m�w����^�AȂR�}��]~f@eQ�xsU+��K4ۇ�|����Tu�_�\�Op9��N�CY��������N\��0fj�k) ]�A9 :>��ɔ6�<�k�5y�	V<XRH-k�a-+�XH����1iI>�Xaa3���%��h�b RA6%�e�[��,�QWeo)�H�I��q)����ˠ��Z}PE�4X4L\T���L7�m���6F���䤁 �B���y��5���쓾�b�f��25bRP�6t�6a킔��p?��R�C���]������1g$,��[1�=���^�c��qK�"����|��E^�P	"�c._��-�$�'��9��`��r&�<y��N�.{|�j)��<!J���>�5�2��"��@�ܽk�	8�{<4+<oVC4k����%Ur�q#0@�0���L�S���$����PG'��B�g,-=G����D��'��o$�`��� �n�I�I�����hd�M�!c^Zp��Qc��)SL�+<,G�����6�*1)02��
c��Į>��΋Y+���H޸�z��Y��� a�&>\��!>*�r���H��R�-�D�0��������'�!��G��xLq;��N~�Bn{�f)Ed�4[�Sh�_bz�+_�&�s�3�MczW�+�1ZT|�q~$������½�4��4�&{ �.VL��'�V#@��JLc��d�ΰ�S�v�)��J�bD�t�Ӿbk�|k�3g>�nڐ$���_�2�����S����o������ƽ�������Y����������u����χ�����~����y�����U�~\��������o������^�\.ʿ������F��o�����~�?��k)�49����[���߇�5�p ��z����n���������k���u��������c�ۼ��\�2���%��)�^�x�rYYQnõ�*��׭�f��mg�1��B{�6ߢGoyW���?z����}k;�%���GKK�2����ڑ�e0�\�����QOA
x���^b]�s�ɗ��T	8��P��&a��:&�{��V�(�eS�t�=����0�7pQ�>/�#��Z�cI�����G�&C��.��%���b��5L'��:w�����/�MZߠa�MS���1�X&�h|jb`�C��nK���#����aҶ E8	L!E������?�,�׺o�P���T�m�� 4�a^�;ӴD�ɇ��ax��>��%�4�1�IF�NE�!$���&���ŷT�H���g���3�[���xo���c��X��\�����RNZ_�&OR�wQ� ��	^��ѹ�[�ux�h�dKnR��T�� ^��-�n��X��Jz����"*R^���&��hϦ�f�^MS:�bT G���K�.hZA+�sY�53��ƕ���%G�1��1��(�p���~�ɻ\���4�Tc�C�j;�:���|�M�"�H��"�%hM���ܵj>���^�։�56��S�{���ot��zeNܧ�|�}�N�e6�JtC�O��t#�.��M���Q5�r���y$Os��y����g+~_���[;��$�e;�v���풕 ��a�*I!�M��g^��R�"B���i�y�F�XE�����a�X<�#v�y�Y��җycf�G�3�o���*Av�i��%M�{דk�h *.��ͩl�U�m����Tv=#E߼�W��6
/�ro�:��*uZ��C߽�Ʋ��W���)�a'�bk�0H�K ��>��F�Ӯ����W���S�穝`�ӡ>�M-05Z{o�������)���P��V>*Ѐ]���W�ո@�k^�Fw��O�J�.�/��E�@�k��/6uV�I�&� ���_�� ��n����u8��X�ZC͘� Ȩ"(߼�8C�1��7�oިW�=T�0i�[�B�N�F�-`�aw�3�mCUq'ƙ��}��ELeO
8�{�xZ{�E3�r4Sآ���l��xS�F޼YARFd�Ǭ�|�y�D�>o�*� ɔ�

[�G�'<;�\����,-I���Z?�#y}��׍��tT��s�ש�g���伃�(A�ّlXt�����6��cJH`����x��߽{dd�
N��"���=)�>l|�A���~�G��`]�6gX�+2 ��i��CX9Fb��İ�b��f`Bh�c����G�P��3��=�dx'W�\�2�ܴ}�Ks]$�v��ǲm�hk��a���A?��� Zs�v�|�%���G��u���S:d��}���?o��m&	��z�~���y o��S�}~�����6M��?�&���1�V"�\g�=�k��+h�zM���ߓ��f�5�c]���ϼ�Ѓt>1}CZ������g�1�M�L��լ�o�,��h��3��zg��#v� A��E�����J1x5w_���WۆH��Mz���?[�H���a%g>H��Tvp��1�D��LzE��$��;��u����x�v�
����Dit�խ퐠�7��x[\�t,H��A�����S�<b�kHe�p=q�u�I�s!l�P�]{1�$��Vb����!���k�q�r��&GlR)+�눱ƭ�mH�Ɂ��yP���$W�r���z{���R�lx�{r��AUB+��OG|]khׄ�~����?�FG�2��Sl�:Q���ѦL��N��.2��Ib7�a|�<4��ӹ��̝��h���w�%����*�z���s�H#���ΐ�N�T�N�8�[K��:fY�a�����U�2�G�Pۗ;�=��������R+���!�6d�"t)���3�*����,da�_D@������	�WdS��s��+]8]Ԝ��9O�W�}� ��� ����6n{ L�Z��2���Ւ%M������Ydc�sY���!�����=��	-�	�]��=�=3�4��EўFr3֨��{��kZ�����B�1]�:�dS�7&��?���}�D[R�+^��[�
�!
�u��:s�j���8*��[��鉋V;><�JQp��A?�A�Z6=2�O�X����9J��2ӷ�a�{2O˾����s�;P����]��ǵ�P���<��J�?�e��Ckj�Z ���ޫSO�F�3�c�>;մCu靦ȫ`he��<o\V/�W^|�n+
Ķ���V�����zI�M�-e��zmѝM�p!�;],Z:��cFtPĤ�6m��)w�#�K\�M�픙�8��!q�	�<>M�.�g��U.�A�w�������a���S�� �d�Z�y(���Ny�N)��O>޾8������kq��� �?��yZ��X켒i��I�Q̯n��c<�]��̿֩�i���2�Mf��v:ϛ)�-�)��ҋ�*X��ʬX>�HҪ�I>ߎ:`��E��;u7����Z��O:�O�'���)�\�4���l`�+�]��p/?mZ�X�8��*�pe!U���W�ް,&r�^����0�U�8͛�=����%[֦b��`2�N��*�I�Y�9�f��%;�<�î��S�}��Cf�Sc�hP�xA�,��>v���KE�;o�VȯI5�*i�1���`u���q6+�^�����-���n�-4��1<���z���:Y�;���%J9�EХ��3\<��onN��oߎu=9q��O���g��&��YMEvclk<�k���_�7������4�q��p�ix�p{���r�s����wN�}X�΍�a�<�z�so);����Č��>eNk�N�T�����?p[~8����O��,�k��StW��DG��z�o�b�������(ll�ϛI+�k�Cyl����T��q�z����q�=)���j�)�	y7���EZjJO�.G��T�����}W;ߡy��֪�Q/�&�F`���3�SC�f] �(�.���\������hj��@&X�fE.��(���5ތ�5:��U�;Sx_,'7�3'��W~��>��mv]0�5��X�˖P������(-�=�;��W�A���J#�z:M�C�Zsg�$��;����5�Hd���%�+;|��G��>���gZ���t/��F�����I��>yĪ?���h�szS����ށj�v	�N�~w���[��g�Y����p-߈2����Pc П��n�?�f�xa \	uB����>�s�L3�1V�G	��4d���;�g�Qq�r��
`����ճr�ɇ����Gm�;Z��ȧ�H�2c`SgGX$)X?�zGRo��E�t��T���5�S�{��5�Ξ[�W��uu$��*,S����z4D��0���R���n����<�uȬ|���E5���',��'�c�ג��&.9UM-<3.8��C/9�-��H�[����M���\o���?�+��YJyV�GJy]��bB�԰�gx�'Oz5�2�'��Z�E�5�.y�L�!ݠ.t��gdq��:��/�� �F����g��g�p�Om_N�&�_P�a?!�˽;u}�6���}�C5�c�3ZC��b���b�YĲ�\6����u��sF�2��l9;)Ӟ��a��L�-2H=
�sH�v95@ж��i�$��D�ԃUbxvy���:��xx�F�����z�Ϭ�h���\	�&}/Z)���;ky-,��&:T�#�Bj�׆&p�a�ڒ�E�|�����A6Ғ3"���0)*�r!Q�9R�t�a�*	�6�4c'Bnǈ,[k���~�D6����ΐ;�j�i�1�]Z��=2��!�F'�n�&	�yֱ�2��p\�e͔���e��V�vD����#���c��Q��yl��Y�8=fr�F�&�5s��i��J.�|K1%E��vk��/s�:"	"U~�CE�������$=��A�k��-�T&��u\�lvn�&�3	ܩ|8I�K8m,�I@�W�"���:pi~���|� �ɚJj�mϬ����+�䰜�m�Uȕ�-n$����8y!6[t�k��)N�Z�B_@�
	�,�sQC�&^�>8D�L|k���4�B��$�{Mݓ��@���xM��>�����LQ�Ӫ�;�mt�l�`Tz�Q�z �]CO�|Y��qZ���i�o"z����%�"ؗ�v�>H�y5TV�~v:�'͟m�D��?wr�X��Bnֽc�
���g
�g��2ed��ƺ91y��Ҷ��0��g�L<A̙w�<���2y1%8~Q���A�P�����3L�%�c����Sר�3zGDgl��
�F�j��Z�cj��n�`ϛ�@vxd�"C���p� !Ϲ��-�V��9c��&�O�Sġ@<��fu71�d��,��2��#s(��a }�R�h�Re&� ��r�ͺ������B�A�A��ŶU�C��)y�7�*���9�Ԯ��
g�Լ}�V3��>Vr�)��3�b����ϱ��uA!�I� M[�������4��"��Ӳ�#����?W�VWo�>����g�[����Ɂw��\��~���C��?�mmn���-��O�W����w�k�?�������_]���?į�����s!��ҏ��)94Ց�#��&���X��?���R��zPs!� �A��@,�~Y�}�'�mms$�L\Cꘚb��&�k�N��?Ɍ�R�kz-�Ge����p�,�36�4tј�����n �C�o����8,��QE���%�o ��>���-	�X)&TC����O���������C�JD�i��yY�'d����pbի$X̭����8Y�.�G>{�$��������'O�Rv�����d��W�DдO%�|fP�h��c��B�2��^�9����x���P����A�<L�^���2��8r2�T2�V<b# |)u���3^)���8����d�y�:Z��ɢ�ƩW�䓈�S��i1���O���Q���@�b@7>*�*���W�,���:��4-��2�i�R�4��zx����T��Dr�AYt���c��K���=K�L
J�L���$HQ��Rg��&1��.g��H�������^3�:H5��[	}��%�Z�KF_f̛�iIq	�aJَ��\cdҹQ�N���T8��e��&3>2��j�^
j��3���͚��nv�5�T�4�FB�*�� �s��y�gr&Q��g�����G�8)n��SF{���O�QqRg���~CT!(uY3�����?<���6��6�z�v�E�M���)��٥����M�ԡJ{q��@�/$O�p�_�BVm���J3]NS�vYq�c9�d+}�]�X�ZO|-7@c*���1��/�<�p$�r�l��W�P�����m�+�����7^ሓ�U��$�b��~C�$��Z�"W���'!M�T3{��0]=8KX8���0�/|�7�Y;�*;�?�;�QM�-	�⊭&#n{w�m���K���2�j�h��bs��)/׺6n�+73����U�YoR�<�h��:���T���ۿIZ�T}e٫)�ݦh�>�?��t�K�iC+!��@'{+Q�U�'�%�1G�SF�9�7�5�iٿ��"͙X{(/�8�\���{o;�u}5)o��L�ԡD�����H�m�%��2����,s�V�I����(���Ѫl�l�ƹ?7ܳ?)�s�N�����6�]�Z����%B��b#�}u��4�0��6� =���X�Ao�n�!iL�@
'�_�glz�/{���蒝���6�LϷ�y�5�n�VX������Y�L� M���={RL:�Q탵�����6ѠX?vߨ��J��5�����W�AE䯡��G�E���?
h��֠��Mg�S���+��5P�\s���Y�	BU���w9$|/X�|��՟�L?�Y<>Z'����}3����C�,��u�c����ד7C���M�Ur�|�E�O�
�&���F?�sZ���r��M�G�4W��1'��/��$-�̶���\�<�B?
�<�	�4-�8ڼc� �*p-=#&B����03�V �& ���N4�s͵F��t?#��q/�����Pkmu��!3��<�����Ɔψq��UB�c�m���F�~*e"�lr���p��+2��:!�%B��Q��C18�q�v�OBS�8߻3|<-E:������b?�`�e�d
��9�
H)����A�%l�*&��1r��k\V��.���m:+�ʸG5T��	h�_��<Ivv�?�_���7!����_�Y��xR�� e��|1nw�,�}�6p���oJ6_P�?E+B??�s�I1�;�Ѫ�N��|D��/���/qН=�V��P����|s�8�g�A������Ǵ7�m%9yV��.<Cv�a>*�b:t*a��zqh+y!8�ק�����`)����~��z�Qx��h��2��ʄPv��4�6�����,�U�ڱ��@�}�ke��fR�YW6sI��s�s����61�\�T)$�0�:�A�s~�|&�{�8�u��u�vP�R0E�A��]�+���@U��^���!�����WaZV�1'دq!�s��0�n�9�j3y-�x�\��xY\:a�����>�?��>�aW������g+�d�_"�"0��ÿ􍜠\v̎���5s'r
!R�D���|=F�.U�[�\ED�i�c��eQ!�5	�����Q��00 �C�\����$i�/$��}�A�:����+�c	/�&gls�S\��
(l�#h�
�|�q�>�E�A�~�X����G�Ƥ�xp4Eb+�[���ٴ���F~ek�^� �ߝ�-l�S]��4��8��ˀ��tDe��#PI�NEU�
O�����=~�T-�0�`��ޜ��70��r���F������̞�@`��P^'�D�B�UFM����$��h�> ���C����&+(�'���~�O�mOǠ����\(�{��������>�!:�3=|B_r���iA�Z��5��#��v�I�j>V��Yu��;A��D�Z���a���P�^ć��a���9D�5�o[�̶}@.?�fg��m��,�_�x�����k��<��2&��h���W>-v�H��Qj�9���Pkʀ�����aN!8�{
}�e�ك��!�4y�\�>��i���0��NQ4Fݛ낸�Tu�����}�cG�7L����kj/���h��_[3��J��<d'��L"���\+h$'��^����W,�X�F�4d�Փ�q=���+���_�X�A�{I�E�l�bY�������������������gx���X�u�ʺ��v$OO��-��ߕue��|��1���΋�R�5�h��o�d�rF죚G�A��9�0��_r�C���dc1ƕ��+ث4�k�!0lQ=��
�.���R��t�@P1̊�Uj�	E56�����$�9SҼ~iR�>� 5-�fR}C\���(~�j,R���h��8���\6(�@�<ӗb��0Z}y�D|��R��cJ����1��#��Xe+?~�e8bJf~J�O���&}� �`���S�X��}�O�vG�R�m�6��z�"O(��z����ꢛ���-�_��x�0ok y¢�$V߻��-x3��9T�m��ڴ��[�z%�6�;�+��*���o{.����qcxj����\�6y7����p�3rxk��]Y�%g�t�9�͂��E��z���p�<��4iu�o�r�a�,�ok�� �&B���o�,Wi��?ZT�:���>w�=��ּR_��B[4�ݬގ	m��m�1'~A���f-h@w��Y}��\�!�R��������dz��5�n�L����#�x��I��M̝,u d��5Q�|[h��>5=�uUE��S|��*~��� �$�B�ja��=u�2����p��b_�,��ke��8,�7�WӸ֜�w�x�OdQ]�z�5(�� ��W�����/���Y���~p�P^�#��ss��Q��8�z���y��_�1����S~��@qxu�~��G�'��r-�z3Q�׶VK�JQ9�򆓃q�mh¸�]ی�
`ﭓ�i��E��ɦy����|��]T�r6�$M����3B#��P������
��]��.��[�v����~
���0��"�,h�T�Bv�`�S�g��d��i������{����nr���{�v��=��Kw�k�Y�"�[5Tws����!c۳�:`�6fH�F���rr9�A��qX�u(6z׷&�1� eˌ��,��UvƇ&v�w'ۼ����z�N�EF�>�Tm�fM�r�74�Ȩ�QGhy�=�Y�7�i��b�T���=g'��g۹P�y��orU
�d��d��-�����|{ݿ1�B� �������J���ol4�r�I��n#NT0��x!��eP6��K����'�a�d�%�4���&�i4=4ұ�Fb���	#���,uʞ�oߚ�����2��'p)���bf�+Fk�$a.��/СJ�'�]�ѰÊ��p{�����Dt�F��<?�}rm�h�`���qM�����[��Z�LD:���2GiG'0�#��޹�.����G\�"_�w���N�D\ElY>p�i���X��Z7EJf�G������`'G�h�������fl�'�C0����i,	'�O�۷7�x'�6(��D�`�tZ�j���zW��]�`��u�o��m[�O.Q+p���L�2U�;����&p�s{ז
iR��c�N�f1J�8�܍�^�8�����Y���Y��y[[{�o�~�5�Hq�FS��N���M�e�����O����*9�L^��h�h)�;ε��kM���oG��뤳�ϰ����s�"�.N�7���[�+��L$�Y�ZD$���p�.�X0�4��aVZ�K]k�{�F��Mۀ�DLZJ����rmk���+d��|>��7vM���ȍG}�}�!�P�B�{����BPOhS��Y������kVJI;�Q�fLG��b���S��P�'j����L�x�c��`�ֈ�� ��i��xl_^�zͷꈔ>�6��;��C��G�'�8��R�D� 	y�G��)C�w� ��f���	�E������qA��P#��=b���� �?��}202��e�q��(�^����E�V���+���<q�#j�U0�W�(̑Mss��f1���Th�~ H#���I�.7���],fB��C��52�"�S��~��a��� ���ډ1X�a�h��׺E��7H��f��0��qIB�����gv8��ݜ��\,=����t���7/J{@~O��rQ_�	�54�GO؃�o���iԣ/�CaT�_<+���b��n05���U8�����-/z��>k͚8��JՉ^M�Z<<�VjS�x%T��.S-y�ƈ +�f� �xe�e����8ܶZ�Ȟ%RH�wX\H��V�I��1����~
��MQ�޾���[[�����v����n��?��������?�^ۺ��q���!~q���͵{[�������_y߸n��z	���X�[�K��3_�n�m��s4��l��H��������ݻ��}�߭������_���Ɂw���qm�V�������ٸw����s��}��׭�ux��������N����\�dR�<��LD��QWV�%3H�����1���M�U��#wW���t�H2�K|�&�O�6����3hQ���b_uY����}��c�;�8�-9�d��I,.��{s)�V���7�&˰{2��J��<�/�
l�<^�[{�(��)o��dh6��I���4&�I@B���T�-���bR�lv�N�HVU �I�YN *��i-�I��*|7)�K�q�f4���E[A7k�j�B�[?6}o���->$_r��r/y�����	��N�8�f�0ȈWż4/0�6f�A�p�NW�~,�ML�8��y�R�$�F�y>�ӕ��g<d��/�.�L�
��|��:n�\=zM���I���ͮUd*W��w�G����5c�6�z��\�m�BO�'�?�����ҫ������pB�	����~ �&wf|K- �v�(5M1��M/�gF��ob\�õK��"#܇EZ��IH妭s���Z�jH#�� �rewNx�"���G���Ҷ���	Eő]��!u$�'Q�N�9�͏?��y7x"�,Q���)L"� ys�;j�pc�b7Mz���=]�B�vr�:Ή�~�v0i!���ƯL��ʓl��r;�1�]J�g�` �!�������/[��H�|�W�b�T�]H��(	6֪�FA"�H
F˺@^ )��ʬ_�?���l���`>a�=<<�c�� !P%Ub���#����q��՞(7��;�Ƅ;�{�~s	�3n���g,����l�P�����贃��Ha��Yn�q
gK��ƮE'èe*h�p/z�7�}w��ǰ�Q��O�
���<u�=��*6'01c��;:�k��l@=wG�@��R�|NRJ�;5{�
���I)	�ᱛ�|VQ�J ��s��ه!(�\i4��ʌ��:�f��-np,g�����&����AoC�H �Fp��\���;�i�Mk���ή۹�uc�m�6��V�ԑ��nx/07_.b����%_Al+&`ַ(l�|orN������	�ʗ*����� ��Y���QpW��̃�ҫ��=�T��G�:��ms��g}wpd��N�������h�^�B�V���pзG#vǓvg��Þi@�Қ;����l(�����V�0�X�sK��� h����;�0U%Ӎ�]4���:}'c9�ڃ�ӛ���F)e�g����R�%�M]*�vx��o��-���E��\^βI���'6g��,�P�_��6:�-},g�N� ��u.?J�t����h�]��`2G�`2�|�Y� �H��o)��n�d���iڐI��:G��u���W�@h��νM2"�mU� �����Q����w������=Y��ܨ��$]|qN�kP�j�c�`q�p»��.n%�p��mf1�Y����=��f1�m�����~��^	7��&/t~n�w�7���ϖ�]����E[D�)4��ҫ�s����$V"���Y]�s|Q��)���͔�UīIPڴ^�vN��T���gir���ZSn�t���g-��V��Ԣɴ�k���(���\�D�H��m)��w�h�Mh3p?�J@3�Z3�	�÷NC6�7]^�0<VB��s�^L�ԕ�i��ɥV���ϽfJ.Q^m�ᚊ����l�R�.�����%�ʓUv��m�si�ܢmF�hܕ{V��p�g(�1���NI)�U/%/r�s�c@�W!�0\\��ň��{W[�e��F�sɁ>B.����Vf�4��9Me'#)0w?�����vt�IY����_bt�"��.�E|�0/�j��Tܨڣ��%;Q�䬆m�ӟ�k�x����q��Z�SI8�~ S/:/���y��3"�UO�c@t�yo_��PA��ꘙ�q��:@��xUVS�+���q�X�$�L��{â(�V��1�Ԫ5{]lܝ�G�ռ/Az��G�]0O)�*G�T�0	�7)9G�z<��z��(ґ�(����vgz���p�bhd�	�CT��D�bYx>n�,y��	*P��3Ԩ����.�<�юN�q���0�҉T�U6A�]؟(`x�&ۄ��5�e����Z/���ƥi֩�sp��y7}��S��S�f���S�aW��y� �:2�{dؙ�IK", ���9/�u�F��[��J�2'u#�}���p�gF�S�¢�6}\-�O�M�Ű�=����݁��=7E���{��aǮ	�P���;؃��ϡ�WxS4�Q,��*~V����1��߽�O��)W]J���GIqT�l��m�e㷼��Ϻ�Y�5��W>�:�|�r����}�����Ke<c�4�^���IW��<^W�ņA�Ng���|(�;8,��Y���T�m`������20���}���`����&���<M�x��ς&�M?la�FIK�/d�n�zK���p�\�}���F�y����AdXpן�/��&�	��=�+���1ꫡ��[�q���.�"i�m��m�wU�\rYIUg� ;4���e�,J��}l��H����)/���A��o�����%ֺ��~��~���.�ٜ�ѮW>��P�[
�����%R�)�B�[�#��G_M��RK"�
x������G�:}�f�n��w�'��.�O�Y��:�oQ���Dy�<��݁�k��D!�Z�"T�j\Y���Ƶ��<벖�ku\��*��^|��o4�0}X^6�_����ﯭ}}?��I���_�=	>n�}ܮ��[��5h}}����Ǖ��ku��>>��OV����מ|�|ܯ���>��6ﯮ�PGY����N�K��Z�x�xN�e�I��@Ɋ�#;��C���hp�kXR���w$���2���՜���s�- #B�U}��J_l�V� J�t�I����;�w�%��Yw4��W��hYJҞ�T����l.X�v��K�50����P�@-9�"��D��/]���Ղ�I��-X�4n �V(p���Wa��}���_���J����qh�&q+Pߛ��������5庆,74"��&��E-��ό�v��M��>Ԝ�Im��a�
���=�)�&N-!E&I��|��?ٴŘ/`�63��P�_0�k��/������|c�����5�n����UK<�Z�5�C�8iP�=k�yG�u�m���u�2MG��賽��V'��)���M첐W�#,��m�S��K�Z>�l}ʘ��ۅ��������W]ҁ��0 ��|���-��F�n�����W�>F��-������?����'_��?����O�i�����_�����GOn������?SRp�!@�Z�=�/oI֊��;i节ott>�� �C	��6��5!��S&%{�Мz�7_��)�<P�|p�g�ڱ�͙m8�DE��p�\�,��f5>�=Tw��T�g�O.6�G���E�p/�g 5'���~�{�jG���s�{�����^�n���BV�A�Ӯ�^1^���������H=ꖣsI���� j|�R��f0�}
�,Ά�.)��Ͽ�T��	<T*��E��
�rL"�Ғ� S̝��wա�ѿ�>\(6F� R�,
��=�J�rЯ��!1��6��!Ю�`�)���.<X��h����Ba(�&�Kec]���$>H��������%1�=[ք�����^�l��VsgG�����^m��ol=U����w��r�˧�g�����������&�B��v�~��8ƻ"D0F�(���rk����fۀ�$"��I,j�^�1n�ڿ�K�\�n5�9���6-�bn�-[=$4v���A��rs�lf�V�	�yzc8e�h���]���	g�o����L���L��w�-Q��o��T�Ҵ��Q�&Gc<h8��Ñ�s���c�M�r{���g�/�����ʷJ4���l���}u4W�b��k���O&b�Qv��M���x�9g�lHiB���!q���/. �>[d��⤄-ĹFReN|�a��7E���тn,B��yٝ����6�F�ag�5���S}�P������j��,�c���I;|�L���(�!>V%H�uN��٥Tv�;i�]1 g��i���0�_l� e�A�j�"Y$C-�;�P��i%9!��PƔ�����`2�W��+�,�MH��C�m��c�L@Q� �� "M��{�������c4�cԝ���>CH.:M
z��ECA�=������ǥ+m�Z��)�EJt6�;��K���x��	�%\��%%�>�a4%�R����#޷D0@�mr��B� :AB��ny���J����񻌎ocR[det@;�v�S�Ni�M:1�?�VBQ�7�|"+L�;^[�)=��d�E'������7�w�����A�3yb�L�x�Q�8��i�X\�#q���Z�d��񂗭r����͑��1+�"p�H5�]�Sm�r���N��|� ����9S�obW�n�kJq{{����դl�ʳ;y�u�䊧8�n	]?ԕ��:��y��e6\�5bIF0�-s�-�SB]�z��it��=��+�w�d���a�������š�ܸ���S�Ĺ_h����l�]�^�^�J�0�C0���0��9��FM}+�fӓ�su>�N�|G!B"�<�=�Xa�Z���PO���rxR�c�?W�ʡ����
��і�θ*���lO��J�L�܅�	�c�E>�rz��RT�q>ˋ?�IG�������?MW���I�-?J��[��Z����}]tf�)b~4[�#Ec�/d�ޝ*"1���s��	k��d|�i�J+=W���u��Cw�ӽ`�C�	�ѥ�9��,��B�ُ�JMj}6������l�J��|��X� �U��|���[��-�7�L����ܿ8�������j6l|�(����Y���V�7���B���>���UKi����i�`y(���m`Sk��uj�w�M�������6H��b�����OF��
.'���TH�-��l/(s͝����%��� o�F�3դ�pwn��
6WV}���`��"(�����䖈��v��ƙQI.TP����}�֊��*�H$��S�$z��jO]\�m6`�>�i=��S´�Hxp�Oʾ^j�-��j�e�b'Q�$m����,�B4#�ը$�����f���^�A�R��$��l�)��Ł}D�+M��~�=�JM�#���e��3g�8��쩣��L��~�pn���k4PV.��=/W�|Q=�4���x�idõB3o���C�]J!S���ʰ�t�
ڏ��%�c?bo {�,��CQ-��M��-/Y�9-T,s�XM���Um�9�0,;�	����c6�ŵ6¥T�E��|D�wLJ���D"Bdhu��v�����պ��RP����@m˕e�T,��V!N[��᠄�'-q՘�Q!(`-��)g��6����r>����H=~��#�ѱr�e���N��vA
xx���*wW����6��T��{��<����K�h4s�1������j���8����zx�%�� AD,��ZCç]-g�H�Rjt���F	�<ɒ���J����L�H�'f3�d�J-J����eЗӖE vr(�nn��낁{��s�]u���.D0���r�1r>LL���`��'6E��}
X�N9��c#z���/���*�N�뷰+����Y�z?슈t�:����.aJ������QH�!��#�.6�`�ԛ�Ij�ӤH쒼��̱����''̆C���R�$�v�Z/`">h8��z�SBGN���6)j9�.:������ٵ��YtJTjg�Us��)�u'�73�3BC�=q��ns�� ܳo;G��Q�����oG��T�(�-���8Xw8�R��I©L�Z�ԙB��{HN���Qb����ȓ)��DN0<��gB�rG��)n0t*d�D�]���K��	I�B�������%�bR>46�>\�!��܁dXMٖ��=H��A�9��o��� �~���#�7�
�Cz��J�1��ag6袒�T��?vq&��6�L������?�oV�Ï�i�ӻ��vp�d2�G����FX��|"铀&��:�''�`I7�y�G�O�.��� G�ۯe91���C�z�K`�=��30`����dk�34���ؼ\��}(���].����8~(���N����&��� z,o~ B�S��)�
�O���-��wk��_��J���`��Vf�ƒ_=C�mٮ6,������l����z�O3�|oS�������ؠĥھL���������WYy(���Fq��ˠ����)���g��h�pO��{*y@�T�s3�����6�P-`�;խ������*A@�T��F�}�EM���t//�xvV�qjim6�(f����U�\����SM��z�{9>����Gہ]����'�(_����2i�+{�2W��]���p[�Ri�Ί�����zƞ$C{����~R�B�m�.`>��H��I�5��΀9�4,H)�4�,�3s|8u�������Sb�d���G������o��$��5-����� �N�|
lJ��#�������]�.��Z�(X��P�NA����g�=��$��pK������5��~���b�1Ƞ\����!����9���h"fE�1���P�De9i��i8Bj�-aհ�d�_'
��p���1���a��� ����Gբ��{�����\ę%'ዛU�3�e3@`@�g�[,�ڟ��X0��}F���Ҟʑ��2y��������5Ӳk��cj�Y�ݷW�L�ʹ�6�t�cD��c�st��Ɏ�Iwp�^��SG	�ݰ�n��P�Ǵ�!2��#;���A	�g������˛:pGɡ��| Rg}_���6+�:��?�]J �ofDFhY�|���.l�*��c�>������{)6-G�IyJ��VN�y�:�_B��y��H4�\q7K���" 
�����Tl�^5�T\^ʬ��"Ǧ0_�����>�iv��ώQ d8Bd�ps�� 	ˋ3X>)�S%�ZJ��~-v�ӝM�N����e`���F�\K���ǋ���^ƽ:�w$I�S^H�Yq{���m ����*,y<h�8��{�J"���-�X/�P{1y�fpl'RL��	��!�\?B��x�CFB�x�R��J�c����pr
]m�%�ɝ��M�ޝI�/ՏSί��˞5����'s�.�Ǚ����&�^9��7�_K��j�0)e�NDiNus<��K��`�Nu�@��=غ[zN�7y�b����F���OH,2A����f�L�r��?�u��=>����E�L�`G������y�݋Ĺ�\�w����٩�ԉ�E�/`�K\����hUa��U�Kr]+K$�<`����I��b���'KW��,�ޏ˷�)�~�8�����J�G ۪�E�ԍ�.|X��Y�RXI���F�Kت�0WRo�R�>�$.vjN�`v�������m����g�k����J�>���-�׍������j�?�m�:��/}q��yi��G�=~���[����_��y�������_������o�������Rp'`�Lx��%�4x��$����*zD
-��g�O8Xڜ����^�ʓ-���݃�A�偃��{�����KJ�W�j
�'�����G���T�s�_?`�ی���6 �5��l�*�z��j�gY�O9�	F��6���c˥�Ѵ���;w���S~-g�;d�H��e�@O��)1\��OK4�sL4��TzІ�q�ɃGS���h)�E��\"�}�]��dPvGQz�fLN�cy�>� p���-��Ŗ�Ex�H����X���"j8��,5B�;��2[	'w_Wg,Q��1)ǩ��!�F]l���AG�����e��3��{��6�dS�\r[)7�#¡y1,QA��9�C�5�Ϳ76,oa�L5�E������@��Z�+�KK��(8�!�Z;a&�舷�����!Y6Y�XT2�{W�7�#c���O$D����K����j�3��XÒEF+T4t��c�Oʹ�����At����o�>uqҲ�xF2������􏇥x}���f�0	��1���!�5$�X�y�C~��f-Ez50v������V:b�X���;M�Q�&�7k\�)C>��FKS��YU�3��;�`����[��b��s��p(>!4�������(�kG��H��d�I^l,�xe�?��D��+�`Ǉ1��Ӣ�d��Mn9kK)�I����eL��F�v�{�`I��j�U��v�it��n�.E�79Cò]5��#�u�����j7˜Č_�@�O�cT��J�� r����|�>�P�J��ib�sSʓ�6|�)�t:�p����Ʒۜ~
��G�hR|�Ć�7�M���nԏ��}|l�ӋWn`Y���>.{&{�G�S��Z{Xj4�Lev�g^���R�3��\~6XY\�b.��8����u-�"�P��i5~U�չ���O���T$T}S�q���உ�og���K���w�i.t�D(�\�7�<�QGX:�o�����&E3�n7��3�\>Vгх8 ��n:�N*����l��b2�:�Li�X���u�j�H��qp�ʺ{"!���,a��L��Z�2��h��K�!�H?���_�0���T'fy�����GP=�[�+C:I�)=Q�Ѡm��9	acs�(�����.��jL�����-O�)uS����G|*Kc	���k�`T7�O�]�*ۢ%��n9����j�H	�[_���^��T��s�oD˰f��Tg���-H����u���*���b���
��R[F�8�B�4H���F��۝⊟F�>��e�=���
��SW�P�M�ԗ]���dl{`�� �t�S[�_�N�Q�'=��ޔx�T���|3��n��l�W����c�l+���4[y�8��<¼���L5Q�f������4��X��j�$��pD��d^�
�%Ѧ�s�vp|l_q:��8bθs3\�6OX��tT
���=υ�>����R
Y_�a�eh��)->���C���xJ\�]xEȊ[�+X\�uvmyY·�.�%�d[L�w�&d����7A[�{I���z]�>�|�vվ�h�%�ؼ�2��h�K| ��C�u�,!t!1N6�Թ?��?C)�[�O��u���qI��"�yRO_�h:h�J1X�)�	Gd���]{��{��ţ:1H�Mp�$7w1�?�l�<���*91�/m�A^��W)�'�YʋWu���(/��(/��>��}|�a����1�*��sr���	�ua�sڏ���s@5���~�K`ԅ�.�Q�\n-��s���}�7��;�C�w�{���1�<���.
��,� �ҷO�F�O&�G��P�hL�o��\?B"��)�4���nʮ��҂g���Λ��z�{"�f�c��hl;�����:����=�������]ݿ��#x2�sW#'m���%A/`���_�&�2=>��������W,	�aycR4��@7Ƃ�2WPM��	�*;Ö}y�r��`g2:mX1�������q5�/ @�ɾ^��+�.�÷:���c�H`'�F�V�׿� �V���%\'��і�O*�ɨ��Αvj��8;K�OZ<F2�A�=�趂��x�9��A��7*�+(���~�&��"[B�9��&�#x�MV2��]�5�HV��daW}#K �C�IR2C�u�K���KF���3���I�C8<�d��N藵�V�,�&Bm��T��s�V�H�:�v�zWD2!A��Ec��j�H菀����	���%1�]�YRA�4QL��� )8wd[�3ݒ��X��4�vz���$&���eo<.�^��!�� z>wPr��S�bC<��Vis�7WL,�c�� +ܽ<V>B���N�d��'���`���/�^̀��1�=Q*��ޑ�ץX�~p�o�E�d�1Vq��_~Y����ݿ8�R����]S��=���(���h?�����IIV&I��-K$ ���%��ܻ����Hܯag�����A���&�&$j�|����3�_�"Ng����ǻO�YX�9 X_�n�ר�,q�t�1YD�����?7!��-�a�9�H���u Ƿ`�@��c%�_H�@VR?���V��kg���	���g���W��K���y���K0��b��L�jm�e%�E2<6Hy`Ͻ��OM�	#���X"������:*�$3=�^�U8�d��������5�GVlړ���� �M�s��W���Qe�3a��/u0n��"RJi�ǁ}\iU��{I�:q��ʶy��:R���v� :)��� t��ڷQ�Q���A��ş\���CӃR��l�/������|P�x�����L�[�ߍ������5��k��������[��M�e����z��������_�����*����G�����-�ύ�e��)��H ���!	���z'� ��$��?������J�Hir�q�}x��}�Ŷ�%#qt����җl���ۋ:��v��-��y���� �h��ƫ�"ُaC��
p� ���T�@c��Dt8�T����-��z(I_+�1�oT-pȂ	�o���j���E
6�����<��ϗdl"CM# xl�z�=:*ό�����4ϋ�.&��:-�;��B���a��~���b�\�g�v�%���ÿ���8Z,��z�p����C�G\�y䷗ ��d��6��2����T� vvW�@�Cٙ�+�a�ՠ�e������,?n�r��	���ұ�GC�p7f?�l�&�0w�,���Y^���	x�T�$+��c]Ag���13� O�bȍ��}þ�d���G��:%_�����aɤ�z)#I׮t��(W�Pn��-�c4��c�5�E�X�mĖD�U���m_�rZ��>M��ѽ&�'1�5峛�M�{F�f�\�Ů�
���l�	���D)�+����g�Y���ɏ�v�*m�g��"�'�@/kA4]f�ؼ'2#��H����G�>-Yn���ڈU49��ʉ�	7�����ގ��gŃ�fܨ�>K½�уS�3�꧞��£�9�ǟ{WL��Rk�ΉQ�Tв�[B�g��gq����8�p���X��i�����|��D��
Nt8��>w���[�ˌ��ql���"AEG����n����6�2�Y�G��(����n�� �G7%fg-xl�_p��8����`2
��iwK3]m�=���l��h� F���l��ň�͛6�A�6������e���sm��c��b���(�!� ��V:}�5B��S���s�G㲍�p����n��[��ޫ���0d�%�w�l��(�����#�0��o��DN嶢�zG �����<:��SPp"�;�|Q���%�#ڟ۬���/獆�9;�����u��P���*�e���v	F���f��M"Z�T�L#cS�M��w򗓺=(:�� O���mT|��ĸ����T��l �i�L�[��.��>Fe./����.�����l�����k�Pc��KX�ӆ��.�.�(�ѭ}z�q�>l6Z���Qaȑ�ì.�R:H�L��2��m0l�}��Tg�����D98�8ꪽdo�lSs@7�b��Q����w����<�'��a_h�D��E���lf�oƀsd� _Yu��eI��ȏ�=������]�@&��#��b��xZ��x�$5������ww[P������1g�&��v{gc{��l�"gV24^͍4J�fN�n������R~0u|Q����^X�k��L�o�H�1�H롹���/�7��T� ���g���[��Sk(�\�"��t;X���X�>��C��$�,#�R�֡�ό�ek�Rkݐx��u�9��t�xۻ����\�WX�d�K���6k��r�Ye4�ϛ5��s��l�و�]��>�ĝ]V*��B���VC�IA鼇k&�e��\��X���uϪ��N�F��d�����!��A3íauЯ
�S^�hϹw�N��܎�s�:6��CO�pe1ۭ/�[��~�Ǟ��W�4�s��� �h�H���{C�vN��~�˗_?̐��;�2em��2A���\����O�(B����w0ye�Z���/�JB F@��y��ԗB��oY���.o�ޠ�ŁVv+�13K�N+��@[���!`XM��P{wX��6�ȩ�A��l�7�=!mq�Z��[]Z�e�Kw�>�?��_��M�`ѷ�V�5o��rtJE����$'*Y���	��Go�vY"߃�T���iw-�/��5�>؂E�ù���09[�X�������/�vax�`�y�-H�|Wz`
�X��O{s��� �W�(&)�F���PY	2s Z��Re*�ʣ���0�#s��iE�|��K�=%���8�f�Cܱ=ʄ��xƉ�Gо�Z�+t@L���R�;\�N��P|q9b-K&���ƪ�&|W�h`�2'"��5����cjf�8&�T�R!h�{��ݩ��n���cԙ.�Jn�4��'sG(���@�nv��pDq�����0;�.%����8x|6K���+d��1�{XOԘ6���D�r:��R>�,Dq�\�ْg!���[��ߐ#H���@~˨���Kl�&l�U�lD7��F�������+���$�ح�Tؼ̓�	��O�,h��h���q����B,������EJ}� .ݮ�weL#:��;�� 2o��V�w�|����u���[aÈZ�o
�8�ҫ��V��=��}W��%7�ԡ��h����Dh���m�T�'p<�R"� ^&�L���]1����e������o?B�W�{_!F����� ��B)|�e�x���PD����?���4�(�$x��7Az�hy� �83g4�vC^�#������6kCT1a�݋��(�C�ǻL�x�j�Lk��P���q9d5�.ײn��Z���w�&�K��q��8�%JX^�c ٜ��$�q���n���:z����ku��>>��OV%����'_���>���T�G#�Q֐j�D=΁U�����'.;/O�"����g�66����ߜv�r��<+-  �\��c,(���D���N��Ŝ�/���l��d۱���T˶���Z�t�w2 ~:�`��GyF���ݣx�-{%�]�ȉ�C�wc���(�����;��*\��&�@'�����2vD�	��*��ZźV��5�ۃ��~I��������{�Z0w!�x��H;�Q3�C#58ڻMp��!Գ�y��D����w�TSh��&R�F�
'�ٶ�}���|�}O�����T<wP�ܺe�ds���q�asK6��s�%�4�lbgK�
'�B�7�)�,<.`vS�,�1�
W��2���Z�lN
4c6�5uJ|�̥�G �W��T�Pl���ݥ��WfV�0/�n�s��	���� ������[�ύ�����5��k�����a��G_~q������_��=x��׷����_�����z��������ߞ�7����Rp�A=+8���^
ok>��Q�>�15vE{K����= "(3�.��s]m̽�Ӂ�>�,ߖ��8���fT�i[W����~x�H@��$�ׅ��f7�v�G}񟇕e	r�����a�M�4�j> �{��3�:ꖣQ&,�����q�o�"ض^�;�S��w��d�WA|�9�)RA)�]�[֗¹�Y<.N����ۀsv,��b��ЩZ��os.��܃�#��2C�莀��2�f��`���\o�w�ȏ�*`�k��F���5MU`�\�6:Z����#>��oD�r�"w�y?o��z�WXY���k%A�$o2(ٕ�Ƒ(1�I�� ޤp,A{LȼSR�B"��[:�K����n����\����| Lf�����, ���K�}ў�w}�z�-���z�'���s {�j2	k����F�K֏'�
R+ޔ4K�]Kf7h��="MS�U�E#@C���2����#RM�\)�h�#g�% �FP���ʌ���v[�T�:�5������Z�\s=Id��y�l�I���Y�1�e4�����`�MZ��]�}R)k�v�9(�ʅ�
ޮmT&�4@|�}�$vbn�b�T.p>�������|��l&�x� ~,��ʍ��~v� y�1v�E��N�s@���רwcQƵPDdV����ͬ�����9�]ro�)Z�����zi#�M�Ʀ�� ׍�?1����w\c���hE��D��<L��IA�n�8j��Yy����l�d�vy�b^��.4�3Z�H�框c�m���y|�T3,�sr9K�:�iK	gȖ�\��[�^[8��Q%����m�a�8�=*�����\�NNt�M���='��^�W��.k�;|7ʜU��,���7~��qH~��{�l���EES�x������)Z��DW��So
b�����y�J�4�y�*閹��տ5����彮7q��x�%�Ns��Pp��ݻ�G�3�A�|i�+[s�3N�����-��Ȑ���$D,f���&��Z({��d\�-�+���V�_�2�l��!�!j��@�gY��|3���"�s��@ر�#e��{F�Zv �N
������N�Mf�]i[���6g�� ��T�)��9�Em�/�.�r**�l��a�I�Aa�0��i 6��ׁ��#���k�UNG_��u¯c��ϗ�^wl��.W�� ��J^|�\|�4\u_z!r���<���+-��6c�9=BYЁ!>��"�=��2r	w���r�zs=|ڝ�3�U���f[�t�J_�c���liNK���G'�g�M���w�P�	��P�����i�m��)���$��� ̪RW=&�@��-���0�.v�υmv}�&���� B8_
��b���	�{3��ȇ /l<��̻vțf��E�3���?x�s�Xea�/@��C�z�KD�&��ꃃ�g��o#�0]s9���B7�DE�����D��֮\��e
��
`�,�z���K��65MA�#�9� �� �����,���7/��HѨMߨ��1�o�tP��@ډ�([����ો�V���K���]}d9�0 cGV� y��E�V��b�MH�,�_��w�rW&&B�@9��q��sC�ϣ�C-Ԝ���/,�;n=���u�󗾥���Oʛ ;���ŝ�!|�����F(�x� ι=��z�kpX��+�ᵯ`'�r6�/IAd.Ѻ�h�Jn��7a,y�P}޴,Mqޭ���p�^g�kZ?p���@���������u j81�|X�}�>~�����r�����:��F��gu��Zl�N���>���R����\�Z�]�:���LOF��������6R�;�΋�TuL�8�z
�>�Lc\Lo�Q�ڄT��b�\��ޡ}�!�HЛ���,t��)�g!_+�U"��2�#*˛	8 s\���αsL�C�_�d�b�@0�Ic6�BU)�ҥj�h�ΡO������
�&���X�w�(���ق��8%��~�Q���"ү��d�t�)��̅u��$'�k��}��(���/�����M���w� �������-��:}��%��'��g�(?�����O�e?�ԺP�Ӕ�L|8\��E5Z���1���p����L�~�$�-S��x�n��Li�݁�fxR��ܦ���~
zޭÐ�����Ş�`�[e!�F��� G@,�f��J��)٪���T��Z�3�_����Ѷ��6t ���3Rxو����Yq�hS�8&!:)ؼ�d��e�kkx@�[r�U7���0�ۿ_�����?x���w#���?��l��������-��&���~��㇏� ������7��ї����_>xx{����t�2�� ����.&������ �.��� ��V��3� *ML�>�xT�[��[� ��F-�[ƀg���;ڀT<��w��z}mᒼ#'��X�e���t}|u�� �Esg���8N�o�L�g\��Bp��W}�i?+����k� ȓ�0���An�o��@5�s����qufo��qMj�ٖ����g&z��.��q��h>��d;軛~{b��E����r�r�r��u�7�l`jg��*�>�Q��u���I�u�L��]�A�Y9�t�#�&au�>EB<]�u�z���6�f�6�=3�7�>R޳��X`OW�w�Ր�K�r���_�p�fj�K��R0C���_��W?	ò��;��#����Ѡf���aV)�M�5�k�uP6��ʼѮ=��!�i�$�������i�8�ֹ��@=���fdu���jm(������H��ו���]��!������z?�CY٪'�5�D�j�!M�C1��iދ���QJ�!�M�J��@)�3�D�)w*���9;���v�����)ÄV��x4��x\Z���pB�i�u#3+��,�F�'j<�jH(R�C	&
���(t��P���3S�����E���ֵt&��w�y*�o���U��Od�H��s��O�������D��P7���Yo���|Q��j�J_�o�C{��a$�6C6��"?3%F�A�VU���1�B���g$� D�ֲFe�^ܑe�K�?�~�7f�#?�~#�@��3��
Di��4G�+���#}����H�b�FΑ)�ji�eLӑ}
����^Cؑx�e�������5��?��'� �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             