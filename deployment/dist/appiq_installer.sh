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
� D_�h �_oI�/6��a���9�{gT�VER��٭��(J�iQ␔zf��dU+GU�ՙU�8j�/���;0�Ņ�.�Ï~�G�O�o~��'"#�TOK�����m13"2�ĉ'N��;�^z�M��/���Ν;�����=���_��f��u���ݭ�����&��ɝ��)�[T󴄮���Y���M��p��Jb������o��_��_�� �'Ϗ��%��g����������~�&wNN��X�����A����~1���YwV��4���_�����w+�o�����0ț_��0}�e��r��Ɂ+����`�o����E��}t&������d2�'ك��[��6�ݻ����q���'w�V��'O���~��r��:���nl�>�����d�⫋���www���1Tz��e��_������ǫ~�~����%��7�`�o��^��g��e���Iq����lҝ~�o =�ݽ�.��ֽ��7�����?러��9p������߿��>�/��ݹ�q�ӭ�On����O��{���Z���k���ݭ���u:���g���@rX�E��S��re��U1M���l�eS�AV��|6ϋ�v�Eg%I�^C�y�̤���'�,���8�S>=K�i�x����y:$GY
%����<KPj������n���J@���l�M+,ux��J�i>.�l����]����l\�&��m�5`�������N:ԛaއ���E^fX�j'�
���H�DV2K��Sx��U3��j_��)4��s�t�[��,��f�U���<��7��$�f�3�W��t2�WC�H�]��L�B��g@�E����2�ze;�'�vEV�߀�F�n|Y�+e	h>4ze�� �����t�yuꪚ���-`f��4�O�GY��8��5zM:�]�E<_�z�����g�-���Pk�b�5�m;ٗ���!� �"Gj�ɣ������Vh�0M:_6�a]̓�����X��`�ǋ���z7�}���yLܥ{s�6Q��(�UL��k�X,�ivY��S�u�t1�we%$�b�q�a�π�ϲ
��c����,��&��F<ȇì��% �l�T��2�t�Kg��O��m���ul7���>��y>����D����,Z�Wg,�3�E>0��1ɑq��H�.(;�9̪�j�5�Cڤ!����V��$돦���n�*���M��U���1��2)�C�z2\LiRA��/�g���*�i�'�j�,�4���bV�6����e�]�c�;,�	�TtCb�l���
V���C�;6�؏:3�Xv�q� �V�|�� ���ҩM���� ?޿�-g�3h��+;��d��b�����@��:ɷ�G�x�-�yT\$i��^���8XY�(��ok����C��4��/b��?�CXk+�3�2��ye���L'��L��5HR���E>��}ou�����q�4MvP�\Yٿ5I.���n��������\#�\Om )M"�R�(�����N�@���m���PoY���%��;� �� y��[�sl8��{++�o�@��甍C��۰�:�	Ji�5�8�����Ғ����/l#���;���3�H��(��|���(p�D�1ȫ�� ""�	l{"�+��h19����_ ��DV�c�Ɋ��O�އ��1x�(��\���W�'��Jbw�`?�ف)�X԰5�����S�{��/B���<!گͪ�4'�X�R^<��= '+� ���;���p��bB��ޖ`4���(_%�F�u��yt�z���H�]��������
�}\]�ߦ~����`���2������H��y�=@��`�qq�@��^>̋I6/a�R�!z����͂~Y\������L&K��΁[�W���K�
�-��(��'�im��0�i�U��x��f	P�v�Z�fE9�j�<.�Ίs�X#˹{�p_?���t��`î�I��� ��X�(�=+�<�8���8Z�M��J�Y��Jy��Ҳr͛xX������q�-�}��ù�A+���ڛ/�t<}��׾v��6�=���ٟj9�LȢ"�ϓ�8k��.���7__�|��?�N�0v�t��|p���v�ؙ�Y5�e�9%�{���	��lT@?��i�{�}P��{OY���`#�����%�b�ִL�7L�<r�Լ�*��E)�u�� �s�f�a؆�e�_
������T���A^�����c�E5J�D�Og)4E���^��\O5ؑ�)���.8K���>����ʷ�~�"3A���me{��������/��yAr�l����Au�@-��V\W�l
�.�Ȉ����P���T^��>F���B6<���ɔ������\���"=}��&Ձ����8��Ӭ����,���5D�7�# �]���՜f�2�#]1���'��P9���i61��w(u�"\Z�|y�,��cT>�a5�=s�e�����	���茣y�>��U�^M*B�ָ��SحG�,l'�o���e�� �B�(U6�ܙԋkU
�߹s�0�=��ڄ�#�ןo'0r����O�%5�]��s�K��s[ -�I��f�d������U}!Y�}���QUwm࣍���ב��VއC����7
�:�b,-)�BS�ZwqU��0(��l��C���Z�,�bFJ�O�EDô��u��F���&��Ƴn_�^�_²����()�2�'��/��|R�:6����U��1$�^c �3R��ތ��m�)튌S��>��Fa�Zߌ�E�}��
�d�>E�p�&��rLh}�]J�]{��h�GL��5�T��r��|�y'!70-��cPm|�#�>!�sF��S`�n���RV|��5�K��NSC�b*<*t�'�9	�g ؼ2�l�vǋ	*�}��~�W�����5He��-�YQ1���ݘ��\N{�o��%��U*l� f����T���h��ڄAУ>����u�/�,�C>qp���T���D�**CH2������|B�G����A!V��oQ
n'<���Ƃ�!P�X�o󁠝<N��iQ��Eu�&Ѝ�YZU �3�g҂=�,+Ѽ0o'd��$횃f��	n{?*�nW@o��1��N�玬H�95ȎQX��bin5k> �h@c�+M�gt:D�g,)eO�c�
H����X���RN�ji���A(�jVywT���6�T^����=S�����Y1�\�*Z&���c�@�����@?��P֥�q��hX�X�ĵ�!�n3�h���1��2�"L����+��н���0/�Ÿ��d�HJ�;8����Ku"�%���������*z@8�%Kr�S��䄭�Jd��j�S��˸C�ɪ���<�xQ�b��ܬ׍��G��NR��c��5^���Q��`�9[ 	��0�]A% ���GZ���s�.�MTZ�yJ�o��zW�%b�^^�����o��U��qu���Q�(���V$����E�#����T�f��iۛ�'�7Kl�lG��:���.���J�~�m��+��ө�t��üvq�'�`�#���:f�����w��� ���O�md@U�ېjtZүlʗin��^�on28�
zP����}x�d7�|���.a�Շ"��/�-��Wr�bo��Bj-��j�|��~g�(��>�r��7���YO)�����,P{2���h|�Ƹ�z���m'G�:�28�e���v�����@=�v�9v���TNf��൝���=)���O�C ���!�X��tj���C�o|�ݩ@Ѭ�<H��s,�~��4���mk����r����6���ƴB s�Ӂ�q�6�n�M#v�V-f�l.g"���b<�L�R�<X���4	�>�Z�u����M޴f�Bw-�qzZHH��jx�9X�f|	���
��x�+X�/������v#�(3�뢮$�4%���f(��|!��D�L˸?����>
ـ�Qhb@��i���E�����h�d(-�:��T���~���}h���io�^[m與�[�k:�\��;x��m����t�?��sl��7��>Z#�"��+�_�Ӳ����b��*�2m�yv���@�dS|���ȿ�b��h)N���]N�`���h�-�	��S�[��9�f�[����ά�<�X��jD��C��E_g�eb�jc�.��H�.G`�g=g�8l���my3��ĺvR�ve��j�x�8��|i�Gn� � �?����E���|zV�7�_�eґ�L ).D�����9���E�HuTM���>4F�8���a~�]z�
�T5���Z8�Pv��l1�Q���|���E�Y5`V�񘶰陱�ͥ_Lӵ�Z��҂�3i�S/�����LtB��G軰(���R8����[�Y:�c���N�Xj���4���M�fp�ʒW��}[�Llpr�-r��ẋ��6��������r�����o~�/�����Gx�����7���w����5����r����6���Z�����x�߽O?���y��������c��2�o��ݍp����u���_-�ϙ�"�vTT�+|U����G.����TpB�ٯ�{am%��B �(��2e�Ǭ?���҉�z��>�*�ܷ����X��P>g/3s�pG�H��	�8�������q~�11�O"m��O�ֶ���ʅ��.ͭqnz&�O�Y'�c3����P��r�Y畿,,���\L�Ƕ���Gߨy�6[�(C�̘<p�X+�.h�Ɇ�t���8��딳P���@�mބwk��S4��'��w�ʋ���mh2l;B�-IrR�W���-�֜Z�>������t�)�-�ZEc���yfP�n�a|t��g�?S�#���U�^�Yp�^�Ð�,Sp����[C�/�W�+��g�АVg23	�EIA��b�!_�@R�b�R�h���_L�nRH�$7&|��l:BU�}$�0� �.rX����va,�RSY���3��|F@��=OWR;���z˰��QZ�x�5�b� �!��Gg͝������JZ���b~�Mz���u���L��ףlJ=��\� �ЃΘS��G1�"&�%�I��U�\����7@. �Y"�J����/R�~K_�ń�V��}�ڼ�_ͺ��-�JF�٨���/p�#��dYx�s��#_ª�W�GN�6�;��V�&��������Ҋ�) X�9o���Q��dEq"��y�bC�N�`��9�{�rA�� ]:<!�7�����Mܪ�����3�Us��::���rL:���y��t�[ZS���;�cE-������0F��e])�L.}��l�9��3�_j����3�u���za�����a��aw�r�I�R���D؏WА��A��B�����1~-WL��<5O�L�]�|N�/%9<�]g"q��9�$D���/�Z�G"���2�0J��=\'��`�):ے��i�+ȡ��Vs�&���cXm�	�Z�<A\d��OA�m�o��V��H�����>�*݈��KʅVC�;��} �VN��$�U}�b��������,�T��g�*u���Q���t��E��>-.:��r�C�����t7�ξ�\7�.�°/_��=Eq�y�ۻ���?&��0���L����]|�ƒ�S��A���T�sT��F�����5�֤]���ٌO����"W~W&Ǚ����`�&g�����e�<�w��'_%�]d奞�ev���>è�N�]7�K%"1������^1Y��r��.��������<7Bl�-��ߩ��|<���7��<+my�9��������:q߁�8	}�T�%��P�>8iڰ�a�YS�����֒��6n��<���r��$�95E뤮�z�}S�C�jk���|'����$��<DU�P�鎼[�U���
?�b.~D�[��!����U3�Z~\����1	h�b�9R��5�؛��Y���7���o����qa��(p&�Qn�*<�K,i��5�>f�w~�gF�>U�>�k�}yrY�#�����!�w�;�w�jI����JK�2������M�����O�S�'�ݔ�Q�jje�e"�&�.�h:)��\��
��t;ׄ��S��n۰�5�����bH<E��󱋂{��
��nR[o2�h�,5�9Q�Cq�8�QSd���\jU�r������_W|x��#J���iJ�_�c]�*�j�/�)�UHT�#�Y�a*�������Ƹ��ا�Ǣs��\eg����>�4��B���9�̑��*-GG��ti�G�l���7�6G��Gq�e�Qh�ET�������cġ�b�Q�����zn����f�\Ϝ��C�����=���v�7�]�϶>�
�)���
��ݷ�	�cD4�)�wK ;��ϲ��ez����]�X�5h�=�"�7\���
��6����ɖ�{v[���?�-Ϗ#��h���$N �q�*q���p��)s�5��X������l�X��`B�������Pi8���17	 ��j$��S�r�o�;�sB �&SՋJQNi�j}�;�2~_&�1Urj�x�_X����X�Y��v#�0�Hj�H�wPa�����:J�3�� ��	�|!���C��!y�}`1� ��x�4t{(R}+�!�*t6��1��F�%��~�`�x��� ���t꼨8�>]
�Ln~&��<���D�;,a�Ďӽ(�F��!�u�7��/J�{�"y�8��e4.t���ua3�&� ^T�-JK�~#ˊ�9�1/���┌/&H�m$��?M��~�߭�c��lɰ�/`���r&�`��JFM� ���������d1v��c'��^@wT� ��(�'����䷹���d���d^�s�E:Q��0)��0�X���l,��ͬ�V��P��K��,�k|�Y(,�1x�X��Ӽ��
	�2����rT3]�8t�K�f9�OI\ߐ�q�+[]36>t�vE;�_����oև5_����R�U��П�!W��18_ ��_S�
������_G���{7�_�w�����5���r����s����C����6�lܿ�y����'����������{w��z�������vp8@e͹_� ��Un��z&e�#�=v�Y`�\q�c:�J��w>0�q�PiK���R7Qy��_?���iS2*�A���R��ڑ�ג���7����Xʜ����-\W�ýRߥ?�k\�~���y�)�6`��3�U.��D&X�Ω����1�[Z�K1.�����S�	ӯ 9��"�i����s�8��*��9�kQ%�ՠ�P�k��c.��F��t�A�X�N��m'�Yơ��0��]Ć�-�Վ�:�i��7��j�⑖��{�R��S9�aV��hj���Q�ֹ��|,ـ�1e"��y&�z~��c�?�����@�%-�C��vr��_!t�%=�b�U���-�h�4�v�)�*�$ G���nb�f@.��v�P�Q�	�L&�����X����N��ƹ>�0�W}1�֧#U����}�[����.i�n���{���6��F<��9�+���&�I�Zz�kl i"�I��y/BɆ�f�c1 #ۉ��T^�pK0��~q����5:��D�_5���-�G�4#��qě߮o��o���][�Bo ��ZfH�Ţ��'������4S�����e|-�D^�e�y�p:h�1���K�A�֝���R�8�ܟ���Ӝ� ���+j�_��Hb�}�)��+@���!����ꡢZ_2�Jq�)�P[L�EB6�͊�٫ޕD��h����u�{�#X�[�:E�}��Ņ�E�[v����1C�{oJb������9�o����h������3��"���� [��l� ;$���L���z� �sU���,,�
S��3�CV�j����mX��ͫ�Â�;'�������}ۈA�(��e:��?�̵�FP~�H�y����9�/UZ��� d�n�ǘr���[�D�%ɘ�&k�w��g��A��3ˏ�A	����������Y�~"	J&��Z��IA�Y(T�b[����+��]U]�IoݪF�b�*7�7嫹�"W/\g9�ѣ�u�3yR�`F 3�S�ʃ!��q��l@>��?H�IX�`�[��z��?���V�1c� �|����VW��[�3�.����NA�aK=�����'h���z�^��\��}+�H��i�?��ڱ�7���.�
��RԋG{B:�ͯM��`K��=�]x�T��P�C1R�yD�N+�v>?�|�#	���+��%��[Ơ̻��+V���`$5��,�y5��ԸH��P��H4��<�V�J��&�#�������9
���vɡ�g爖aK*?�4M���|˝���8�#n���b;�)�=L({�v�p\�Md���_貉@l��A.���~�Q>X<�Ϊ.������2r����H����>�J&i۾�K�C,W=���bw8A��ޙ�p �����2*���|�l�Z��7�r����R�rbLG0:Y�7t�E�#��zc�ZC�r�o�WY36s+O'���Ϛ��;�1�b۟��g�K��V���,֯����VWLo�����S��yS��*�J��0Q@�&���l<�>��[X�o��)��o���ܢ�׍�g���"c ����Q��:1��"�-L�W9�F���qA��"nU�=K��8�욉�O.�t#T��ɧ�7��\�fV;M��\c��]�/���=j����?B�]���s�����*w��10�K����F�7��܁~j&���iv���cIK_Ν.9�П�����>��q��=v-�z��=�M�t�J��F�u��.>9B�y6x���Zo�ǵ�m�j��ny*�A]'�=Ev�b�^-�Y�(�j�
_���C��]о����S�[k&T�V#�)0#��|V��м�r��Sy��[���k�V��uu����F��nIߩ`�|"۷����ͥ �V\t�>eЀ�J��xk	)��V+g'�~Q�zF{�5��Ki�b�7f�?|c�}io;����<,@!�Ĵ���S�?�UT叼I�h/qh���-|����<S����>�M־�N��!��cO��|V<�N��|t٪����o���u�b�q�״	�\���Km�Km�R�4���\SIڬ������[3Q�a?�޺9z���Ҕ���S77�M�Uظrx�W�>�X����|�����q�][��Y��)ou�p
�p.��+���U�"Sgԏ�s�9�QA�f�&�շD���|S�g��Ód��y�Z�� ��cQ���3�꒞�/[b�|1��#����pEe�3B��%m�3e'��{QM���l��:��惚�N:j��U�hk�����bN��nǳޤ�G[��w���
n�YS����
wl�&^�j\�F�g��}=��ft<��������|p���^	@Y��5�_P�0C�"Q��v�>�)_�#0G��b�8bh;�<�l� �u��ܺ��'�-�Ԗ$�
��d��Jza�x�Q;K_ٔ��#�������V����
�1���G:�዆��6H*�嗵ϐ�c�����:1��/�u��j�xR��m 1]4���Z�I�r;=h�<琪,�ne>5��X�Sȃ[�S�����Ղ�s���d%	�6�FR��Qy4�G��V͋��>@��wk�ۥ�jG�&��%	�rJ�=��j��ZoKe�tVe��R������XZ�w�����1(� �
�c{z�6���S��;�0[�<k��W�"h��k�yn�~��5=��D�2;�q?"�oU<-���z�g��E>V���a�w1G�6�;Φg�Q;R�!��씘/��s��d���]biS�O��j}�~#x�C���pW&R�b�ИC��3�j��1�j3 ��9pF�2�S5)
9�\֚��t���UW�d�W�)5���#<���r�}j��8
5��D��K��/*㓼6BkG��Q\�o��]L;.��\��K+�M�0�`i��	�����E��Z*����cC��Ɏ�@m��|Ho�@{)�7<PlM�?�C���\P@��W*�}��#eA*�v_1ei|��*����l45b���&S�)U�1�OaI�V�Wt��^���~i�̨R���!�H^h1�۔y�Q�Iԋ��, #�����h�9V��vG�qh'c׸"���T΄Zss-8И�#�$C�Gb���k����^v��4���Y�a��(�@[F��IB�aۂ,'�|����h:��<�^�=�r���%�s`'�+cO�K�M�,H k��Ҟ➡�D�u�����ڗLvb�ɤ��3�o�+�L�s]�N6nO�+K���Ș%�W�e��$6�CD�r��'��FMB��lۿ*�0[��ƽ���m`	כYUQ&���$�������I��
�V�|\ 2�7�1���771�59j���g7��@ɶw�)9v��>˴_Ľ����u^�+�����pG�����!�5&�YV�c��4ɿ}V��~�$�����3m;���S���q%�%7yǲ�aN�U�WJ�*��5��aUPiZ<��Օ��N���%�\U���g����5�bz��@I���g��Y!n>�x;���y�{wBR��O�NN9G�����lg<v��3u�9��k@Q�{1�ʬ�� �s��KT�u�h��e���y�ꪓt���xh:s����B���Cs���[�b}Һ���z\�g�<����7��I�<Y�{vT_&;���k��N��t�O�PK��6�UN*,��d�~y93��$H&�·$��LD�����t�>���S��_L1�,���\�ճIsS��O�N���Ha�	|c��HF�	�W:���UT��M;����'ԛ�:�;0�*�����H�E���T.=��/�����A�~:�t@�?��#�V������{}�g�vڈ��>�z����J3P8��B+&�۸��Be)7#��&,k{hE .|���ƛ��M�����n�l�`��4Z�����k�Bb��%�+���%R�+���,�pe#oj�<����Ha�������	�>]u�G-��Α�������]�;�n�����i�!�Z^Mj�覝�6+P�%�u�+�Ksݶ��-���B?��t��f��@�ڳs�����I�J��>/B�}���O��br
�EL�6�D���?QB�m�_S& �^@�T�]�,�q�3��ƶ4�����I�+�,`���,�$J��l9^��'Ԛ��_���֘�{<��1M+8n-�6��Mk��؅��w�4������y�s���R����!2#�M�j��b�)���8��������n�h�?Ŝa�lQ�r��;���Ԟ�j;+��C�K�Oj�D��\�J;
�K
���@�󁖂s�qU$����'sF;,�3���Ԩ�!8�vڇ�
��/�db�����mЧt� �x�-hιƲ���а#�!�13ԉŮ�M�	��?�ʆ����w���i��q��|��N���&O=[O�G:ǳ�IF
��.B��L@����G��1���M��A��&�c�IAO|eu�ȇ�S���`�O�tl�p�S��w{k%��䓭_�CH���*�G�5��+݁Jl]�R�S�fc[�d�A�XE�a*� ��dGK�@G*�8B��)vK"�'C�S�.�~uP�dn���U=k��J���z���p�����~��Af�ê���Ή�G)b?R�#�z$C8���X��V��1/�h�.�0�Ӆ\��v�$LW��J�9̣z#�Ƽ��J+�|-��S����tq�û�oz���o�r����Gtz�AO��i�9+l�1bZ�dDʛ�yB�*@pK�1��XY�Ԭ)<ܬ��^+�����%5�N-Y)��� �����;x��5���~@Ч��,�O�C��N�PE�E!�h (S�m�Q�1�C/Ø�t�E�K[���!���ۓ��!�/��o�q�
�G���bz����Z�����?�o�ݸ��� ��ϟ��	��ǔ���q���;7�����������Ƨ7��?�����>v���������p��s���_��a�&�����
�ӡ瓅n�e3ڰ@Ka>���E̮>�����6;G�湒&��@�QvU��|��b��FA^��@���e3�'G�vE� m�@M���鎕����	N�״1q7|��� ��ϯ��ԓkrE�6�)�O�KXˍBY��*��Ǝ��ז܄m/��)|Q5�N�Y���dkQ�CR�\��ę:��&��4]y�K�sLen����k"\�x�Y�7u�gq��̦���>��ԑ�z�5���(��$;��E-�R��������of^PM�1u祟e��k4IE��������d:t���6/�6�O�e1���h�T1q �=;�F�}9��&��dV������~Ԝ�HJ��2 ;�m&'G���Ig�Ć�P"��x����Hj���ʻ�sj�� :k,�Um������$��4&R%�dz��JQV	����'�mZ>�T�Eh�H0�|/�ޫ�Dnn����.9�}�Av����%�6��o��T��E��$H���#;Fl��n�;���+��i?��埋�����4���������A����;��x���(�t|!u^��ӹ���gZ���#��Lul��jI��~>*�[�ڟ�S,��1����H�vär!~�M?	M��?�oa�)�������jD6E�o���3̍��j7!�,�쉂Kv� *-�3?����`��O��%�N~�T������ wr�r��m��d&�U�w����u*�h`����}�T�KO�Z��:�Wn�|��<i��9�W�ݔP��DHI�4X���r�o��Àzy��ΧA	��d�˫ ��<Э7F惚�W]W��j���CV������5��(6G�1?G��/(f�19<�S9Lxʮo�M���X��-���]��g
O�9`y�G���&{��@�R����3�(0ø op���� �ڙ����;`7��Q���Tؾ�&�IԸ��>A_�`�[�:�cW�V[JI����O@�٘�z��Y�[��-s��dN}&���`bh3�!<�k3	�����o,d�g^	f'*A�2]PfJ-i�e����0\�m5䣀�O���͏�#���yA���XQ�z���r傽�b��	Ȣ[�V�����8z�-�UU�u�ɭ[�*��b���j���.�k%)�ꯩ<���+;
��%�{_ȗ]�k���a���%�n���h����AQ�p|+��6��d���m�ݬ;/� ���܃�ґ�tJý�r��ʔ:�Ei�9���"G(�Ǔ��P�u�q��+��?��Vه1ª�N�xB&cR�z��Bd	~t���}�[C���|�l�>��n�ݷ��+o-��G�@y��;��C�F��jm���cL��ҠD��[��F�hUGJю%Xv+�<J�I	)쾵�L%�-,FO��C�c�YY�V�l��4�"�ܖ($��"���&��tg�%>�o�QW�lN$^�������_�%#9ا޶-LmY�i-��Vआ'o�c�-��$�f�p��qw3����'��k'o�AC� ���j4Z�Zh:Npk$�a�8F���M=��P:"����5�~q��Q{��31��nA�/n	=��3���5TX���(��*��Ǯ�����i9��DS9Xͼ�a<l�������N�^����~�jc�q�6Z��v�+7X�^_�PI���& ��M�h�:��w-V�����B�pU��)�M��b�N�נ��#�E���L{�1)f&6�Κ&�;�|*��)e}Ӳ�ؗ�ڡ�Ә��u�E��[O�0������@5��]�`[��PN0�Ş��j;M'776ְZ��%�2�mRq� 8�C��o�� }Z��q��cڢ��7�o�\ɣ1�ȆC�zdb*挪��G�r6=��-ؐ�PY����|�����:A��o�
���X|F;��o�}���呞K����$���������TA��z�u��������DH���~onh��#3U�����啇���x��(Q9u��)�a&��C�Oh~���κ��^�����P�\�� 2�5�n[6��W;�A�@��ろW+����)�h3����7�ê�5�)E}��׋��!k'�-�U�����>�aR��	3�C�0xIG��5��@���0�f#s_tWh��
M��/v)a�J�"1U����c�]��<!6�;���.��w4��bo���o�����Sg�\,���$�����������)��ڀ^*'�o��1�8@�R��w���ɾ���> ��	*޺v����~������މ:@������U��>��F0�`��۷eM����V�[�<X��(JTyh���.+j� ^�-�4X� M���0%�'X �Jl$�Kja�W�a'jw�9�$6ҫ��y�o�ah���l�N�u���M�>s�8���LZD�B �:c��~ ������V�%���.�b��h�='����Bye˜=� �3V��iC�[�b������e�K�j��R*��ʳR�*#�Ȩ:�]�nץJ`U��Z��J
�w����a|�g����I/�)����gյ��q
Mep�=�T�u(���VH���,�ϭF�'���y剖AW�[�s��p����U�q��hH�JFVFD�S嬪$���{	
LZ?���C[P�0��n'�/ej�V��>�K=x������7�b/���Իo�R�����s%٪���L�ĸ� ڴ�:���R[҃7����#ǃ7����σ7�/S/V`�'<O���l��K�A,�YO�z_��?��D�3Bv�^&��W�����$��8�Ͳ���B>�$}}R����������;��4Y\ ڕ{����5Gc�C�%�/a#��J�i�h��B+LQ����]��1������ȡt�\�`���rc��Իou+����/p:�W��D�d�ǻ���x�qZ��6oE��FZɵ�1+�A�ڳ��"�7���e���8��`��q��LS�������������V�K���%ӵ�N��N
@���3%���c�᯿H���0'�A@i��,�"�%���W+b��[�v*�t�C����G�mn��������5�˸V�?ݸ�=��l�K��zA�#1t��2�T��*�9x���Fz"�P8"��b����u�ݖ-J��qlm�[���pi>E��x#/��
��b� �Wޑ5�ي�n{y�>�3�������_({���vS���u�b�+�6_�<P�.���r���T���.�n�$Iy� ��I�j�!��
)u�#rv�n�X����)ox݀���M$u�rkw�A4�D�.'@�R�X�/�ՠY���=>0ͷk4{�mb����;���ۗ_.�����N| d��3�"��@�7�cm����Df��?��e�bʭ����9�O[U�֍�Cr>��A�0ӧ�-X�<�d�3��=j�Jg��A�#����i�햒dx��u�!o-��1�]�^�q'�XLM6�w�δV3)�T_*��l���b���~���x�ʾ�l|��	���
�9p*<��������\Bהc�B�V���3ŎtT�H<�&�I��R�S�L��-C�	�� ؙ����>��_]%��	kO��n� +h�� ��?�����XJ��\���Ӟ^BwxN��R�	-��`���i5���1WY��b�2�ƅ�(�5#��?N������d�KAj��k��3�5��}L�'�y�Я"�dRQؗ���QE���5�^+�I`�\�v%q�B�q�"O��˦�`�oMZPg�+R�m���;���OG��o�����o1Yn�(,z�RHLV��V�X�QGj�y��%�0b�o��+:�PC�b*	M�`Jqx�v�g�G�?<���������:l����'�z���X��S�*M��B[��K ���uw����EM�yq��]���)�L�A��~�8�~l�.�xT>Ϩ1��Y��hM�3g�3�c"�e��x~xV�A�@*yѲ������wۘ#�m�龘?�����1�P���*��q#�45�2���8��U��G��>��q�[[�����M����������Ɂ+����~o����ˇ�E�_666�ݹ��~������~�|�����_�w�߁���^z�~��?��nȐ����� ��{[[7�?�w������w���(~ ������k��6?�d��ƍ������=��W����wַ��s�����!~'<�/�p�������S�g%c���Wxm]����ȷ����=�C�)�W�3��}�q��N�-me�d���L�M�C#-��H�)��)2{cX��n�/�c�2U�)�8#�R��ǻ����r���H�����2�Ky�Ӏc�F�)�����F�
�Ю���K�9�I�b���cx�D�e�d�n��f���hjHy���IZ�ڦ&�����'_gcxK��+X�VV�&�ul������ O�%��W0��	&���x��Fم��{Tj5 ǯb��ò����D�a��\�++��;��;�k�uluc�ݾ�6�hG�(M3�+���S�N�9� �����M���f� �'����ڠ�Wkx	:U���� �RD���P��h�_��~u�%���z�(�q�\_�3����H���=`V㔹�5 ݟ!q6���ͬ���N��[]y�����0��i].-9-���X�HI��6��\��7�f*���9E~p�i�Y�p&r(��c�Ј�u5�w�/JE�~�����|x	����X���H�8C���6~3�����k#0(7_�?tm��h_W$��M������l�
��-�QB#�VV�Ej����o���a:�]��u�7��@�7{f�.%�����m���B�G����$�0��U�.l�m�pȴM(9+3b�*�c��M'
�s��ȱ������Y��</�)��L�e#������la�s79�f:��5f����u�[�-MjAB���ߘ7v^Je';3y��M���Ʌs��9���'��`>ڶ-��3N)�2�R��V�����������΂��ַEZ�9�B�����e�G���V/ûDO����-�t����8Rťf�"�#i���������l ���,�U���C�x���*�٢�cC��@�������� �i�?����%��,��i�$�ѥ�N4ir�F��Aw��Y��>��A cQ���!s�Y6V!�wM����� �`������<���q��5�@��8F��� P7����5dƜQ�*�N2[ʧf����XT3���m	�t��M�7��q?s��N'P���H^�]Q��ŕ�����3�b[坢ef�Ws���~��f��PYs�\�J�z��R��=n��c��U��W-���\�sD����@V.�9�>j�c�A1̀���ZJ@yP���)öE2�(�iM^xB�5�R�Z�EX��#R�&���BLZ�6VX�̴~uI�$���T�MI�@Y��(�j�U�_C�"Rl�"�@\�Օ�%�2(ơôVT�2�)'6�����`cq ���$#9i �P��t09B�I�F.�dఘ�y��J͟����]��MX@� ej3�O��Ԅ��PmxrW����t�	ˬ�CLxϡ�����,Auܒū��h�98�z�GD�+T�������D,	�ɫj�)88��I O�8������Z@
13O�R��p� �̅s�H13�=�o[6D��>��
ϛ��Z`rp`I��a�P� �(*�9�TF.�5	$"�3��	hG��++ϑ�8z�2Q:�*�.��� ��[d�~�``���&�qS?F�X����c��Xc`����
��(�y�𶍴JL
�L��X7D1��ϥo��b֊��#�7n�^6�m֢�=@���W1��J���?R�Tu�&Q$�x6â)Bp���	(CH�쑴8S��_���^1�YJY;�Vv��B�����җ��I���b�D�����l��r��� �b���l��p�)M)1ͮ����5�=�	����ı��n1Y��3l:���Y
�v�һQ>�ᴯ�kߚ�̙����6$I��������}�_�g�����w������~s��A~7�??�s�yr������mݿ��������'�~��u����O�gW��q��߻�o޿w����C�����ڰ�rQ��xg��u��|��}�ߍ������_K��Ɂ+��� ���������C�6>���l޻�ɍ��������v����]X�����u��������c��|��\�2�����)�^�x�r�YYQn������[9�8!���c&�=���m�E���2�c���Y�}k;�%���G++�2����ڑ�e0�\��tp�j�QOA
x���tQ�?�.����YL���Or��SG��0��F���m� +|qղ)\:�B��]��8�|��s�����l-	ر$�Py��٣o��Hn�t��mzD1������
�;x�� ���&�oа�Y�����Ԙo,g4�51���?
fwA�%Ov���!f�u�0i[�"���"��EeAПi�j�7S�|t�e�L
�6�y��(/�YZ"����	[g�0��dI�X����$�Z�"��{NZ�K��[*N$�L����{��-M{C��H��1��,i|�@RPis)'�ot�')q���t���s���\��:<z�J	��7)wi��I ���M�}B��|%�o���d)�\
zi׏��g�\3�Q���)�R1.�#���%X4-��Ϲ,욙�!P����ݒ���}�YBi�ODd����]��U}d�1�z����D�w��&_�$�}��&Ώ�m�Z5��n�d/J�āݚ��)���G��7����2'�^�g_�Sj��������ȼ��8i�t�n~TͲ\-�;q�Ӝ�rV������������$c	j�N�]��~�b% '/F��JRHa���홗6�T���<G��D�s���%AVQjuA����4��]n^e���eޘ�����vt��J�yZ)�DI�o���*�����~�3���*�Q����d�3R��q�Mm��)���C�\V�^U��}���f�_Un=N�Nr�֖�`��W@x�}�q��]�9ޥ9��{߁��Ϟ�`�ӡ>�M-05Z{o�������)���P��V>*Ѐ]���W�ոD�k^�Fw��O�J�.�/��E�@�k��/6uV�I�&� ���_�� ��n����u8��X�ZC͘� Ȩ"(߼�8C�1kO�՛�7oԫ^?L���P�S�Ql؆u�]����e�PU�߉q�go߮mS�����^;��4F�L=�f
[��՛�7o*�ț7kHʈ�����_a�6ѯ���"@2墂�V��	�z�뼙y��%i�P�\�G\s,�{}|ݸ*O@�G�]>'�?�-�gLD	�ώdĢ� 70qO{&�`�2�)!�eh#;�c�ѯ~����5�M+8͂�#[��L���U�+n�� ւuaڜcy,�� t��Q�wa����Z����	�A�I��ZECu'Ϙ�N����\�r�,r���.�t����O�f�}��Y����n��W߃h�)�����ܽu؏ԟ�����t�������^�/�L,����3��6���@8�<ǧ����e1O�m����M�3��cحD�Q�
��l{�׆�W�"=��4��'yU�mk�ǆ�#h�yM��bj��.��1�cC�4��Tc��j�:%�Y�5��YE�T/g���zAG�8��U�:�K�Q+/@�b�j�n-�����'��:�)~�.�,y1��J�|��UOvp��1�D��L�E��%��;��u�WI5J��Lc4�.��«[�!A'o"����~-�X�L��l%QCS�$yĚא��z�r�b�.�B�"��
��b.Ij%��2dcX�aC&�g��&��D��M�ؤRV.�c�[ې�9�����q99H�y��O��0���k�$����(���,�V��������>�	-����ϡ�9~���e^g�بu��5�M��K�X]d*ZW��$n6��8yh,-6�s+�;G3���-�K}U��$֯f��w�FL���!S�>�"ҝd)p~��X�u
̲��|�kb'+�:e��̠�/w���+�9�c��#��\uYC.x+l�TE>�R�	~�g>U*+��Y����6�������Ȧ�g��W4��p�,�9M��3�Z��3��A��O�5@($194m��@���(e(A�%K�D9ge�����V�Z=
��C#{H�Z0,���B�{b{f�iF��=�:�f�Q'R��N�״ă��߅�c�Buz�f�oL_�~�9������V�JϷLRCȫ4��u�,�L�IqT,0�:a��,v|سJQp��A?�A�Z6�	�p��GJ��z��������,�r 6B��w���>��T����u:>���i���±��yhM�B��#֠���L`�>U1&�Ӟ��K�4E^C+��y�z����wﶢ@l�J�iՠ*�i��D�D�RF:���٤���Ų�#�>fDEL�nhӦ����]�ro�m��L�y����cL��q/�� ����CT������&�Wïg�5�'O�k�����clh��$���|�(��O>޾8������kq��� �?��yZ��X켒i��I�Q̯n��c<�_��̿֩�i���2�Mf���[�͋��˔NG�ek�,�NeV,h$iU�$�oG0x��s͝���|�L���'��=���zzJ=�$Mb��G&X��n�h�"��O�� V4N+�� \YHgz"���?*���ao�a漪�yӲG"�����d��T��L�Uϝ�"�䛅��j.�^����vݽ���#=p2{􌅣Au����K~���d�5�R�7.m��Z!�&�xR���� �^G�ե.�'ټ��x��.R�n�����E��h���\W����d]�;��(�A�6H��q�У�����o�Nt=9q��O������&��YMEvclk<�k���_�?[���4�q��p�ix�p{C���r�s����wN�}X�ε�a�<�z�so);����Č��>eNk�N��T�����?p[~�����O�S�,�k��StW��DG��z�o�b�������(ll���I+�k�Cyl����T��q�z����q�=)f���9Rj�nJKŋ�Ԕ�4�\�R��v����}W;ߡy��֪�Q/�&�F`���3��!L�.��y݊��F.�O__Aw4�	�!�����"�S@�^��oFt�~���)�/�������+�SO�B�6��.��q~��eK(���u�uЊ� j���Tx߫Ӡ�Kz��xI=���סm���Z�M�y����]&2L��Õ�h��#^@�}�3-��'݋m��*��*�E��O��O�:4Z���*�(F�w���F��S�_���c��6����F-��6\�ע��38�#��'��8�/�;^WB������\5�LC�x�G���Q��;������l\\��i��"�hp���p�awm�Q[�V�S��6�������I
�O�ޑ�[rhQ.��-է�qM����bk��g���qU	t�
������Q29�g���tv�g=}&�b2+߯gxhYM�(~e�	K��I�x������Kz���g&���~�%G�V�yk��r{�)z��~���C�B1���gE�����8)�tI�yq��|��W�-��*y^+�lA���e#�i5�tn3��,tP���k�H"��]������a���'7������	Y\�]��5�"l��1����h�S�ĳS��f��s�|8zZ���-�r���8���L��>�-gsy�� I�x(X�!a0ڥg��ms�ӢI�͉Щ����� �C�u�e�� ��=��/_���ya�$	/�`M�^�R�	w� <�ZX3
Mt�jG> �Բ�M�T��%��@��ӋI� l�%gD���!`RT�B0�:�s���$��UNmP#.h"�N�܎Y��py��lb�;C�ԫ-���Hvi��z��0��L�0���d$h�YǶ�t��qq�5Sgã^�d~h4X��?Ll���#X6�ѿO�w�汹�g����ɵ}X�TW�3��:*M�(�q,�@�ڭ�/��U�$�T��5\v ��JBg���n]���U��Wq��ٹ�w�$p����%�C.ᴱ�& �~�V8�tr�����Q6O��'k*�}�1<���?�,��r���W!W
���D���>��Y��lѵ��֦89k�}eH*$ȳP��E�x�F���2��qoӈ
!L��l/�5u_^� -��M4������3�3E5O�^��8���y�Q�)bD��xw==�e�:�i�N;�%N��T���?���`_�Z�- ��HYqYoO�?�4�P;2�$��:ٹܬ{� ƅ+~����e��F�Mtsb�b{�m��Qċ���x��3�\y��e�bFp��N��a�P�����sL�%�c���Ӟ	�kT��#��36C�������m���چ&<���>��7�Y����= \$@�s.�di�U5(D�X�y����{�8�G���&f^�?�G��A���odcE�0,�/W
MQ��$DRQ.�y����7V�[�6(2(��ضjsh����?%��~@��w:>��
|�p�z��Ӵ���(��M������<|��%�
N�h�R��7�~�|z���O�������%�w�����7�_�w�����-��������?��X���~���!~q��O�ܻ��'�7 �?�_��G�������q�n��~�������C��?��a?�B��X؟�CS�?��m���a?����aA@�<�ð?�a*�q��5�1���s�B�E>��q��6�� AR���5���)��l`2����L�/��!.���WТxTV.�� '�2?e�IC�IM�{�"@<����/~��>��~�$^� �:��v��%kŔjh��_��Iw2:[��px�[���0�:+�Ŕl��\N�z��C������@"��E��gσ�����=����U�n�~���񋪖�������c� -�~,���A�R��Ћ	ǿr�O�W@�]��8����I�/0��Z���GNF�
A�ԊGl�/�3�+����R<���2O^RG˞2Y��8�J�|�rJ�>+f����b<�0rY��G�U�c��j����zg#��ezV��Z���V�.�U���*�H.0(��P�r��|�� s�g��iAɓ��ڛ)
��TB�P�$�Y`���_�4z⿿��k�Z�f�x+�O���Vku���L�ys9-). a>L)���b�k�L:7��I�ڙ
ְ����d�G�^��KAM;�x���Y�W�î��F�*�f�HHY���q�1>O�L�$*���2P�����'�m�q�h�20����1.�B��2�<�o�*�.kƋ	�Q�G������F_�|�N0b�(����<e4;���1�I�:Ti/._��D�in��|ThÊ���]i��i��.+N�u�� ���l�/�k\뉯�hLE�:<f|~����X.�m����*�V�S_��z�!�t1��+q�ʘ��V̱`�o� ���DkY�j8�$���jf#c/����g� � ���&�����<k'_g��'s�7�)���%�T\��d�m�N����Y�~P[Y��ߔ�ClNx�����Z��ƭ��p�&`�:#���@>�Mʓ�@-��uB^T=�?{2�o��M���+�^M!�6�@��!�I���\Z0OZ	��:q�[����?/�-�9"��Go�k�/�rp��E�3��H^�qZ��a]��v���jR��M��C���Q#�'�!<�G���4+"JF�Ep��{�i��5���z%[{=P.��ۣU�f���sn�gRg��\&-a�m��t���=<L�J���]�F2����4�0��6� =���X�Ao�n�!iL�@
'�_�36��Ɨ���P�^v��U�O�����|�i+��f�?
_��W��z���A���=-����������d�hP��o�zM�I�.&�E�+ڠ�������"�C����4F�UkPDئ��)�L����:�q#�9��\�,��*anrٻ��K>���OKf�,m�PY����nq�	��!r�xԺ�	J�t���ɛ��ܦ��*9�>Ѣߧ�k��t�?j������|���]�G�4W��	'��/��$-�̶���\�<�B?
�<��4-�8ڼc� �*p%=#&B����03�V �& �&��N4�s͵F��t?#��q/�����Pk�Ν���8"���:.�>#�yHn��	!؎�G�I2w���4s��C���� -_��U�	a/yB�4��F����;��|����ޝ��i)��ܥ��&����9�.'S�m�QV@JI=7�/a[U1�&��k�X㲂�v�=��l�Y�W�=��
]LA;�zw�I��c���G�	�Φ0��hς�ē(K���p��fI���㶁4E}S���~�����'Ţ?�<F�^;y�����s8K��Aw��[9�C�7����t���1s����P�Q��x�Ye�����iF�����ȩ�Mj��š���,^�\s�9�R�����j����`#��5�e:^Е	��X'Nim��#�B-Yȫ�c絁��j	��6)ͤ��l>�H�-���@݋�mb��@O)$�0�:�A�3~�|&�}�8�u��u�vP�KR0E�A��]�+��ao(�*�B�CS��m�Hc�0-���׍���UJ�B���e���M�l�U_�,.
�0Ă���u�w՟f�w�0��[I��O�ӵ�l��/^�k��_�FNP.;fGc�ٚ��9���_��m|��r�*�-]�"��,�a�̲��]��	��(�m�!l����P�4�[ξՠI��W�5��ⱄ�l���9�).BE���A�־��v��"� yG?r,J��С#kc�@<8�"��-�p�lZI_x����/Z������W����\J�CL�T�e��b:"�2_v���W=Q���.༬g�5U�+�/��<�7=��ƽ�]�1<���_4������� @���WQ��`U�Q���z�8	�2�������P��*}��
J�Iv�_�@œw��1��ԖEr�Y��ca�\|��g4D�|��/B�K�sr9+�Z�W���q�0c��;iU-&*��?��{'(=�HV��X�2l���9
]ҋ����7�:[?���m��ٶ���]�l"��m����w)^*�)b����C�:m��I�t1�cC��뵇O��6��w(�	�ޜPLk�5e�qJ����O�0����>�>�2��A���k��<h�h���4��B�x�(���UA�f�:�e�o��Ᵽ�&��B��5��bO�V[����KJ�nk��r&�vn��4����Z�A���+[���h��ɇ��Ÿ�������د�k�^mQ>6�X���|�{�����4y������^�Ef,h����Y���Ӧl���we]�n�^Cah̡h��}�!�*�1٣������C�+�;:�����l&�X�q�c�
�j���y� [T%�³K#�Tf<](T�b{�1�EDQ�;-���%ImΔ4�_�ԧO# DM˱�T�W �s4��Ҽ�T-jŀ-0 ήܓ��h�g��@�F�/��o�W"X�vL�p�b�:f�|d�P�l�Ǐ�
GL��{��W^5�����m@�����"u⃍x���8��Rm���#`axB�gWK���WV�݌^�m��j��k���y[�U�%��ޝ�m���t���n��4Ц՜���W+��ߙ^z�W1\}�s	%/��S�����j�����`��M�����[+��ʪ,9E���o��/�ԣ�/�s��DX�I��#3�[�;f��`[� �5b7 �'`�JS�N�ѲZW}g���׵浐�"��ز�0�f�vLh��l[ȍ�8��j��5kI��p����:���j�$�-&�����&[У�Ywce�e|M��+�`L��mb�d�!륯����B��u��8�UgO�y#P|(�,l���H���
���-���!z�\������2�u|��Tǯ�i���޴_^��Zsf߅�	?�Euu�a֠�_P�^-��Z����g]F�����By���^��i[GU7�T��z��y�~A��
x��^�f�b������e=$�rO���J��f���m�����r��'��Єq������['C�B��<��������f�%Oͻ�`9�l�I���Qg�F*��.��3�IŁhY;O�]�·�����a�	�iE�YЊ������gt��72�:+������O�������x�/����?{���0�ٳ�E �j���(>ą;%-�C0ƶg�u�Pm̐������bă��㰌�Pl��oM�c�Aʖ%Y�ѫ�M�l%�N�yc��E�ѝf;����]ʩڮ̚���oh��Qܣ���f{���el�L��P����{�N�϶s�t��+��U)���&v����>��S�Q�����J�D�&�3KT2�+������ʅ'9��8Q�l���ZL�A�h�/ݍ�~�H6�P��AÊ+n"�F�C#�k$�
�0"�޼�R=�d|���M%Eޖ�>��H�L<s8�<X1Z�$	sI�~�U�>8�캍�V�瘇�Ǭ�D <$���������#�h�G{{�N�k2�X>`|�,�2���z� �����9J;:��q���euyT���=���b����v�6� �*b�����LC<ݽ�r���)R2C�>�-���.;9*�Cm��=G7c+>��ٵeNc�H8}:޾�F�;�Ay<&�k���ZxW����Ӹ���jkf(p�C�o۪�~r�Z��GeZ��
��܍w6�C�ۻ�TH�]�u6�Qj�1�n���i��x��͢|��������x��#��F��7�����pJ�-o�-_�X<���ߥP�1f�Z�GK�@Ka�q�m��ZkJ�/~;�\'��}�M���� iw�pB�-ܲ_�~f"���""Ud�;u1ǂ)�1_��҂\��Z[�s62$o�\� b�R����Vk[s��_!�w��qԼ�k�$G\Fn<������j:ޛ<���zB��p��"�G�(��_�RJ�9��6c:��_�7�9��r1U���0`�f"��>���P%C�F�� 1��b� ��c��*�k�UG��ɬ	�y���<�>��@��ܖr&R I�?��O��kp�� t7��Oa.�W��6&����1����k�M �Q}�	�,c_�;F��s</xE-B��LT^�-剳�Ps��Ѹ�JGa�l���6��%m��@c��A��ŕHui�ɜ���b9Z��ʄ���	�q���{u�5x������N��0��E;����-BսFJ�X5kP��'�K���HT=��a������b�G7\~��N�(нyY��{ڍ����@O���>z��\}STwO�}�
�r��Y���c�u�����v���dE� �oy�{��Xk����P�N�j"�����R��+�z=u�j�#7FY�4χ �+s/3h ������
F��(�B:���B�]��L�ߌ�/���S�u{6E�{��>nm�������wn�?����g�s���O\��C�������n�?�/��|������}z������U����q������w6`�o��.���|�����?��l3̳�#y��B,�w���	 n�����~�?��k�?~49���?6�߹��>įA����Z�s����s��}��W��x��������N����\�bR�<��LD��QWV�3H�����1���M�U��#wW���l�H2�K|�&�O�6����3hQ���b_uY����}��c�;�8ʭ8�d��I,.��{s)�V���7�&˰{29�I��<�/�l�<^�[{�(��)o��dh6��I���4&�I@B���L�-���0�K6!�U�{�l���l֫�6�XZ��u�#s#.Ќ�ӕ�ha+�f�^�X�x�Ǧ����Ň�K�w^�%�_��8Aw��%'Ԭ�X�����6���
ޏ���	��7/\ʛ���5�t��S�Lf�l���ڥ�IWaל���\Ǎ��G�Y�_S3��@�ٵ*�L�*��]�c����f�ֆ\/��˻�\�	����Y��Az�T�3t�� N(;A�=����֜o�d�N��i"���i�%���0�M��bt�r��Sdd���H�ַ 	�ܴun5RZ�]iD�@V��.�cZ$���蚽[�ֻ�9��8���8�����$��)2����gS=o�O�x�%J�43�I�$o�qG-n�AT�I������YH�NNR�9Q�O}�&-DZ;���Y1X{���ڎzh���Y%���)�GA�(6t��o�[��8�5��)z4�s�3��%��q<�M�-^DR�d��$�d[ F�8�#Ο=p~nlľ�<�>�VfUee֥J��3��U���ߗ0t�=.Pv�MD��L���=�G�"Ը�6>�c�4}��ԡ�{��篡���Bt"��� g��(�5����9ꎪ�cýȡ�<qY�IR[�a�#�"����
��Ђ�y��U�N`b��96�wp7ٰ2=�G�2@�,�Rn}NbJ�;5y�2���I���@����z!��EŃ��9m�ه!�Ti0Ʊї��s���Lu;��P�U���)�z����.܁��������Q��|�M�nZ�_rv��m�#�slӺ�xv����Tv�y�������l$���
�[a`� v!}�d���M�ɱEW"5RU�`�t��+*+~B�cǀ����C.��n��A�"<?�Űt�-�D��^u��ќ& ]�_Ȋ���ݰ�\5,���#���I���~�W�Rs����?��0�2��
�-{j�[y� ]����'�*x�:�Ec;H�XKI�>�$6���0r)�jv_�f K��6u9���:�@I�[�9�T����e����7NuΖʙ����F
m��-}�g˜�^�%�\�~�iW�a�2�nC4x�Y�����eg������t����J���hC"��ǩٵ���W?Ch-���-cD��.�A ��]5�u?���w������}^��쨱�3$]xq��P�b�c�`q�p�;��n%��̒�����({(I̢��$g1��*��Ŏ5��ֵF/tnnwv6w��ϖ�=�� S�.�Z�I8`˦3gu@KaI�DR[x�� �Vyr��d�M���Δ�Uīm��q��k����"՗���r������p��ZjM��E�h7. ���Q֣��b�26�$��R�1������f�~Е�f(�f��Go����osy�c��h	�O�/y|1�g�_PW��G�Z�
"?��)�%Gy��j�k*��sX���rm;��G6��S��|��>̥Vr����q�7�Y�����l'ȯ����R��~L^�r��͎�_��pq���J�^m���.D ��/9b��`�+�W��Р���4��@���Cƌ2���'e��o�~��%��7�{tqUü諹eS����~:�X�Dq�����r0Q�xpj����ak�N$�W�L=�<����]����z� �;��;�2��
r�����	�=���K���U}TLٮ������bEz��(0%��-���[-l"��Ө4�Q�bc��8���x	�����X�xJ!�P^��"�I �I�9���hLěE�4G�xτ�Gش;�{՘�G�����&�	�ŋ%������!f�pM�9���YC�H�.�Iv��1
vt�{��C+�re�c\ug�ޅ���2Bd��վ&w����_|�7X����:�z�W;摒��}*���,�8|2l�s0O�V&u���47�� �u�=x�N~�H��`��3�C�i�^��o9�0n~���i�_4ۦO��f�i�	µ���|���vK�?޷S�����_��zM`���`�M��>\��i������l��\��gUYx����˳����rͦ��{�dG�˶���m6z�K�޹��u#Rc�x�rn`Χ6gM�F߬�<�,�]
�Y���2z���t�;���uQ�6��tb u���C���Z&s37���e��~O����ågPe���5���^�������u�*�vI�yMr�~����QK�+d����e[�Z�K��	w/�>�WUL�������00,��O�{�{��~��P]����e��s�8�����N��U���*ɩ���������B�2"%V�6�G���E�Gה��ޛ�Af�o�����%�z@�~�
��~���.�ٜ�֮W.��C_�[������%R�	��[���'WM��RkDP��K���� �� t��m�!���Oj�]����c�ԾE�}\~�y��8w#t���b�L둊P-��9x5��ֲ��l�Z���au6+�.xqp5R�z|�����v�^o����[_���u�|l��}�������q���^�G۠���G+_yW�>�7}�h���>�<^��}|n?�[�������k�qm�}om����:Ȫt� -�s*^��\�W�Y�8uV�K�	�JV����$R?TG��\K�2(��#�x8`0�!U?X��:8e�2"�\��-��Ŧk��D�A�(ߝ���z��]b��űq�cmx5�M�b�gs��H��l6X�t,ݥEi��Z��s���e�_�?u���ɜՌ����-j�4j ��)p���Wa��{!��<_;��B�2"=*��f�D�@Q|�ڲ��6üׄ��ܘY��5��Ho.ӂ���hH�/ׄD�}�9���� ߉��S��i�%F��ҟ/_��OV�@1���L��W����������>�;c�9������9J��v:�u�bϱZn���V�bO}�у�l]�6o�@u�2UG�(��g{�7StT��'w4˗�6��LNl���Z�O]j/��j�ȯ~��	c��o�|^���T;����'a@>����[�Ǎ���?����k����|���[������?�z���o>������絟�����G���������o����K�?cR0g��Z��=�/on�ջ�8tU�7J�O C�1@�P;���MG��#�aJ�$�A��4��K18���X�.��3Ƅnhm�f
8Q_N�S�l��l��U]�]��
�l�����v�|!��~i�^��! A�	n��ƀ��޸,���5>��W[�}�ϻ�J]�
du�|��n���꼯��W &ED�q/�k�l�[���"%2�M5�}
�,����˳�s/8�E�|��t��b�V�B�Ci�`�������]q�t����Z@r�E&��!���]I�TV��[*�!��o���U�[���}\x�&є_7���B`L�-#/��uY���$�K�����-O�MwL�����-m�����/;:^H���+`��ȳ|�6�6����+��]23_����Y�`cgo����t������8�_08�����Jx���9�1YBr�m@~#"��I4jaN.��
R�^�9��/Y�Ȝ�����y��p�7莮;lOo�av��m6���υ���<�1�2���C��6���݄���5�zK�g�E�}��8ۻ��[I�3P'�i:Fݠj��5�Z�/䰖�c�?â�AzԺ�^�����l�e����^�N��T٘�]�/�'�"]�p)��Ɠ��z&;s���&Hdc<4�3뺁�4"ۆ�!r���/6 �<[x���4�-ĺR�N|�!��WE����"n�B�e�yޛ���Ѣ�6�F�QYCl�|<*�S���}_�A\`�_]Y��Eu� �{1��o�ќ�a_ E7��*i�̩4���^1O�+z���3}�"�u��R�ĭ��!�E�o(EqW? JA"_9�$G�s3ʐ�_��&�Aq�����	�w;;R��<��&���� ��?��n=oݏ�J;A�Y�N����FA����h(�����C@^��t�-P
["%�H�Φpg#uq4c3���)AՄ�����<��4��!�SCJĞ� �o��ȵM
w��D'H�3��/��=^ɔ�~���bl�^�9��v;�)ݤ4�&���E'����b:�&������e4]�D'j�����W�;SD��ɠ�=�W'#������F,���9~�Q-a2ށ�h��V>閮pu$cĥBc���\�G�X�,��[��P�z��3�w�Fv���Ц���I[]M�n?Υ�.�+�␺�t}_Wv��l���ӕٲe6��1�Ql�c�m��"�h����Z���ɤfX���$����>��w F��@�u_)=��m}����d�����0�V������ūx=����)�#Jޠ�Է\�6=~:�Uor�;�!$��3�ѳ��l�('x�	�4-�A<�G��8�kA�eΪ�뫺��=�%��3��e~:ʻ-�(9�`��J�̱l#)��o)"d;��ş�4G�����ζ;MWw��I�-?B��[��j����}mtf�)�~T[�"EC��g�ٛ*"!���S��	k��d\�i�r+=U����c�p>
�wAd����Ks��!X2���#���t��c8��C�9
���Yj �V���qd��n	��t�D2�R6��bX��;J��E�l��xAh5ݙa��&V�3w��A���>�0�+R�&�����Pt˕�¦6��-���7yG�g�{DOl� �.0���t?��	�]Nz��(H�m�Y_P�ۻ��q�1s�׳
o�J�S�Ī�wj��
6�V�\��qU����7��}'6�%b-g��*��Be���>��Gl�h(��D}?EJ�W**����E�%��c���aL��	n��4ȥ��rԭf��5vUyOҶP�ˎ ɒD3b^�J�dX�";C[m{�Tݫ<�Z,"�ڀ�;��M1�f�P�C��JӮ}@��e�R#�Hs�Kޢ�LÉ3�B6{�hs�2#3}�G$��J|���%ڿ�
ZȊ�$wbOs�p��ÄE۽���DPw����r�����o�9d�GR�bα�7{/D�}Qa-��M��--Y�9.T$s�XcM���Um�)�0,=������6��.¥D�E���;������!C����y�痈����.����:����rh[�,-�lYŶ*qکGU�SO;�1ۣ�W�Z��R�(=$m*�5�#M	��\.r("�����FG��Q���R	��(��5C+�El���s���f���}��Io�n�I�Ff/~���̎F=����jc���8����zx�E�� A�X�����O�Z�.��V%:�*���A��{�5J�(*"�k�{T2-"|��͠:�Y�Y�Z���|�,�/�-� �ơ,���>/�Yc�;�CM���!�q�t�����Q5Q�볪���"��	Xm�N9��c#x���/]=VV�h7oaW<qm��(�n���.�u "s/m�����Q�(�CSvB�0�;����oJ*�RO�"�g�Ŝ�[9�{erJl8F�"W��(ю^K������uB�Ӥd���Z��˜�AA�[��Zތ�,:%	�ig�Vs��)�u�yH2�����J��Hh��F��k�����{�m�����A�G��`];�ϥ�F��h�V����p���Kg'�2jjaC�d
	j��!)uR4J�ŚBN"G��SY�D� �1�J�ҧ�EPЩ����wm�S(-V&$�	�?���rOF�hH�I����,�pŇC�dD/�Z̶��^j��́�x��qLσ����x��d+�鐞"����V��Y��B�b]���Ù �C����7)������4|������Lo�����XȘ�=��c.�&fQ��D�'M0BkI���%]mV��=`|���q$9��~5ˉ:�]m��CZ��id<=����[��~H?C�����K��;݇l��=ڥ�,������K�4j�`��߄��TU�B�����Dȣp�6)�X���2R����p�=�ѫxX�!x:\������W��P�ek���Cͦ�&4=8��҉�
O�ڿ/�x~Щ��ϼoy����lP�R�_&6��L�	EB��k��{O��C�8:ۥ�r��$�ɍ��g���<➺��Tr��);�f���k�&mz!Z@zw�[/4�ӡ݁E4��){I���*�!��"3��^^6��5�4��l6Q����q���f'�ѥ���-�||�����lz�ӗb9�\qbk�4[�^ٳ��Z��VLdqf��E��[���J-uZ���U63�D���,��(]HY�����<�|R��X��J�]�nC`�R�R24;����M�r�Y���+X%|A��;iT����a��L"�|A��NH~���'/���=R��Q_ˠ�M�d�9�������k��R�Ա'�t�$����qr��������0���`(�d�iw�uw�d`E�*/���Y�h�& &T'�DY�F��o����|�Y5t'����	¡E�� ~L�xrT�:�S�{],i��"8���F�Y���Ut�I?�� �(�b�X�G�?�ܱ `����0�.�K{,GܫJ���cK����LG�����d��zo�:�����sYl,6�!ƈ,��j�(��I��i�:B����n�~��[��bZ�����__�A�c�c_���Ɨ7v���B'����N���=@�mV�uH����A��Lm�м�5�@����ѫ<ޏE�����*R��ش,a��'��E[9�����~	���,�Tsŝ$�Њ�(��[S�U�zUI�rvyɳ��+�L}�3F�����ն<;JC�������A�8,/dLL`�t�@J�k	����T��;Q��=N�D�K���:��u�^_�%<{�uT�H��<�����b�ו}��Pj�"����ѠY���E"�t�|@�fn�F~�ڋ�K7���?�l�@M����e��L���	a{����Z8X"ծv��>�S�ok�,�g(Kn�dB���L�}�y�R~-ڨ����ތ�~2��Ҡ|���������G�&��-�����D��TW�㯿f���T���}�[w�B/�Ip&�:4�n4�Bb�	��ul4=dr�;f�cZ�[��jTMN�z�2Ń�IB|gPR�G�10��."��s��?Z�g��O'�����4q�|�7G���+]��bThz`/y�K�(}ПL�s���>9h�ʈeA�~��-ΐ��C��� ��l�VB�8��V�.|��@݌ӅKvt��
��xz�F����j:��۴T�O�=5�#0;L��f��y���/���Z���_Q��������-������������>|���-��M���?�������������k?���������O�<�=�o�/��J�����v��gip.F�I@맩�Mh�H<z����-����ڻq*O�DS�{2��� -e����\���^RZ�ܠ��0�䓟��X�]������0�ی��e �'�^q6x��z��j��a����d�&�mHE��Dsi��6Rx�O顛{ʯ����G��ӿ��!%������F	�F[�JڲA<��#��h��z��-%���@�k�Ez_��˹�Vy�ҫ6crC�0��	 ��>�|�;d)��Y���D�щЎ���)���T��� �O��˳��p㎀���*����R�j�R`$Х��;�J!Ûז(r_�W���@X�-r�>l�@�h�f���DI*Gω�,al�yf��-�vl1E�$r�8�%����<��K��A2k��jb ��x�z�$��e�#k	��������z�c�ui���h�s�9��4:�:���4ְh��
e�����0�L>L�-~
7 ����ۼ�,��4�>�Ip"�
�����r���#"�%M�a�c ��7��kHjb�����њum���؉BHF�[Dt�F�yc]+��4Q\v@��ެS%��t��M��â�&soV�����nA{���ŦC���ЈS��΂��W����M�Ⓖ�\z�J�J�	$��	V�sA�a��d��n��v6�����G�_�&�1٦���U�e$N�+�[Z��B��ۑGO$ѥV����&"�����ݢU���f�j�K�'I�4s1~��>	�Q���W��M�x���I�ZP�L#�R�|,��
�i�ә�CeG�7�ݦ�Sp�>�E�4l�x���(��@�H_;''��1�x���퓼���x��#zʔ_�b�K&}��LN��k����]j�tf>�+ϪեU���㞌�]��ch6���tO��l��T$7��(��@YB�7��;��H��v�>���4��f'�Zr�s&B��#��w��I�&��)|����6ɚ9u��M�Q�� ���.���w�QoR���Fg�g�17yer;��'�(�sPK@�TM�ލ*�0B"���0A������f/ʇ#Q��#H�@���R͜�����o�A��o!��$��TtD��UWK�u����y<��5��+N!Ԙ�wc[$�*S�>O#��T��&F>7���(nJ�N�xU�E!J�ݱL�1)J�U5���|O�U�L����y,Ò��QY���.H��W��:�D{��im������-#���v�S$�aw3Ԉ��Np�O�Q겎�ʯa�q���n(Ӧ��˶-ހ�K2��3ð�2^o�������/P��(���<����x�yT��+|%�n�l�W+���c�l-��1W[���7�0����25DU��s����OӨ+�0H����FJ�`q*G�!M�E� \��4ޖ�o����S��q��1w3\��6MX��tT���>���.����	R
^_�a�fhӢp)5>���Cz���xj�*���*���2V��2�����_rK��m6�k���C�áy@�m�%>#Ħ��uQȞ�V�})�$M$�u�ye]� $��`������0�Ѕ�8�\�����k���l~� O����d�+��'�����lR1�q#F5a�,6�B������b�P{xTG�p\���;��I�^B���F��K]��%�U��Ɗr���U�ų&ʋ�&ʋ����M��|>��8L���=+O�:�!�3�.lxV���Su. ����O��7{�i�J]8�A���1�q. ���/����SZ�z�O|س����A�HJ�lP�Tg^
0-��D�t�;t�iUA��}�Q��+�s��0���R���s�)�z���@Cz
8oz�{�ю��M�mo���s� �q����Jw�XUl��݋|<��# <��rRW��8Zf�z���e`a
����ؖ4�W��bqP�卍�iL�Ƙ�`�̖TSut�r��/�P��N곖c��s|Q�5<������y�]q�u)�-�QǍ��^"��<}���Ř跌=,�:a�����ptZ�OJ���V8�1�+r��,[>i�I\�v�Ѣ��#b`���yu�\��P�l���=Mz�E��Ds@�Mb	jxčVR��.�m$��Yְ���%��ĩ��!�:��g���J���S���I��@8<�x��N薵�V�,�&B]�὜��s�V�H��n�W��"� _Ȃ����b�tG�G���Bӛ%Q���̩ f�("R/1HJ	�o�}�[�����Բ_��%1
�.{㊹l�{��7������xR��0ģ�ņ8�?������o���Ǽ�(��{Yx,��6��b�X	O�gu76�σ ��<?�zQ�=ۇ��H�4��ǚ^���t�k�xu0�-R%Î��?�����e?o�E��� ��b����Sh�2�@���E��9�e�F�D��LJ�2N"��oI"؄//5�m�޳N(�@b�;������n��Y{j�kB�F����Z�0�qsX���4��%�����}*H7L�{a�Dċ��S2�B֟��8�ZR|��>V���D�J�Fw3��J0tI��_=��1����o��5����C�<�d�%���������f6�&J$xt�rϞ{���v=J����ey8D�fR�'�({�[���@����%C�7���_�a<�b�=	ͭ]P[J�p���Ⱦ^���*?�	;����n8��q/<��K�>��J�8����L�wK?����� �#���^O0	���:o-@9�]eP�頉8yX��+�є�`�Tt���������?xu���{_���n������k��_�>pu�����������_������<�����������S���>����Ǐn�n�/��OH��%`���|�S�\��~I�1!�S�)�!��Yǥ��:�Q����m�,J�Fb��D=3%/��z��/꠮�A2n����#W/��Fs���3od?�!�}��+�R��#Rc����d$��QY�8 ͷ��:��}���~��C0K �xu�WW#A��R�I��f��h����tI�&��2��&x���q>TR��n��`��f:�@䲣�,?/��b���q=�yq���@]�ᅵ]zri`����j�$�K�	^/�����=�h�E�Gz{���|Lj��5V�ioشGemS���[� �%dg��,�y�6L��'�Y~�ॼ�#\��e��46�v�~��
I4`�YD�}+�����)x�3T�yI��'����ۘQ�'E0�Fd��FR��-�r���`L]�dbK=瑤W���WV_n����c4���xm6��j[��Y|W��}A˩}���4a�G���ڟ�x�֘�nl6��	i��p�f�JZ(�c��uGDd����Zx ,_F�o���fY�;�&?xۙ��%�8[2(��|t��D�eƏ��q"Sj����Ϟ�~���eY{�դ���TN���q��l��Z]�f��q3tY"��X���:�~W?�\&y`�#O=8�ܽ�`2�X木;������=�'.�=WjK�s����c��e�oe� ��׮�p^@������s�Q��s{Z���z�h?�`�c���o{%)��!�J%6c��C1�I�D(0A��n�����qpA5�p���jR����tNz���.��CiV��b����\�&�тj���kL�y��n�Q����7׺i]6��)����������{\��>�=w]4.ݨMK<�m��&�Ͽ�`�^\���![59��d[�pY�&9c�9��k3��ڝ��Qn3�<Bo"ؼ+�ʃC�;y'҂A/d��x�n�A)����b<����hAi��p��eV��>�����N��~=��Vg6�`aPR<]���m6�r`�/%u�Pt|?7.|;��d�e�q�6u9�۰��t�&�-���WJ3e�,��$�-gk��T�l�����k�Pc+��9��jC^�%p�~��h׾y6�}�t�V6�uaH���QR�o1�i����s�F���l�bX�fר^�����K���mj�W�@�USX����g�������
�Ōk�ް�}*8���0`ټ�P_Yq��ei"p+���=�������@&��3�%_�q�����CIb}5(9����� <P��7�w9�#b��M��������v�ٲAT0��Z��x17l�Lz1s<v�$�NՀ�򣚨��LNT
��B�\��.59��U#A�,�#����ޓ�,O���)<0�c�qSKl�8���Dp=�F��b��`�F�cV�FՃ���tIF�F�ۀ�?S���4K�uC�|��j��77�;�;�ޭ��'�<��&�_jW��YsD�c�*3���0Ͽ�(κ��p��l�cO��e��m��nm5�<.(�{�f�[�љ����q���Y������ߨ��lp�jc��d�/i��pk�AX�E�!v���9w���M�8�#��wN�u�ȑ>\YL�v�
�j�������=�A�?� @ƌ2�!��j���֝cC,���x��%��3�/�֯�]Y@[������ß4����I��i�0���W��;H��l^� l�?���b�A A}�d=���. ��&��XhE�a�j:�fi\��BSh��hS63��%�4��bY��K�-����'�m"6Q��~\u�2�{�Ś;� ޟ�N�.L�Z��kT+�ZPz_^��"|�CxU���@�����^�4��g*�{���ӗ���kl����\AH�-^,I���W�dL�d�0�w0׼�-H�|�;`
�XF�o�foMX/?LR�h�C�%H�h-�K��
�>r��,�X���Vl���`\J�)Yt�DY�"����P&����1N�<��Us�h�bj���b��Jw{����Kki2q0<��5��4�F;��9y��C�ǏM3C}��0�K5,e������rdO�pt�
�� ��t	WrM�i	_>�;B��sư�f>��t����C�fS�}������eӤ�6�B&�}���H�q���i�!lNk�_��' ��PF\
}���Yh� ����o�4���@~G�����2�ƹ	�lU.����#ED�åg�e����H�5[�=*
l��aԄ��å��m4�a�XG�i���sX���H�Oĥݵ�iX�w]ǟ�{���bo�o�����C�����6�lo�o���p��&��tj���5s�5����KN�Su���#��f��D6����mW�'p<�R ^F�l.��b��2b#�7�2q@�~�
��~���.�|�h0�]�\�ׇ����K�+*��u8���}�-��������FY5�'
x㥇�VV��!sF��7�9��.�O�wH2�}�y��8�)�Yl��i=R�a56�Fޥ�Z6t�^��_��ds�7W��D	++M$[�0�D?�4}�k���DO���q���F�ǧ�q���}Dٸ����U��A���!�����9��S����9���qR3|���� )Cu���f�Ѐ��nZ�x=�g�y�y ���z��������0^;�1����]�U����s����O��k)�M���{.�7�������g<#=�H�ڗ�Q�����.`�������/���eNq��x.jFj���ւڅ��:"z�^C��eZE�V�Ϟi���2Z�,,��y�	=��dhQ݅��1"�f������m�# >���S�'*6 N�������(O�7m2
P�pl�u[�7h
�7��:Y�X�A��s�ή[r��6�[�[6�Z�ѽ���Kc��Z�!v6���r!.t���B�f7AȢC����.�T\˟�I�̘��M��_,sno��e���"�/f[rR�;wQ�����*���M|������y-�"��߿�����[�����{m��G��~r�����8�����=|���[����/��^��?=���G~�������&���P
�,�ױ�~��K��o�[����bSPc[��9�/� �2��e��~.�����"s:���G�����*nF՜��I��=��g�z�PE��6čiv+�v]��yTh� �H龈zߘ{A�?���ۇz7c��^^׉��L�2:����`�<0xC��HN�ޭ�����j3�)RA	�]�[������=�Ϊɨ���6��
�6�h�4t����ۜ�:���>��P0�#��6����\�b}��Oz�rh�L䷣-��(�������
L�����Fg�6�p���[�\�ȝ���?l���
˳>����$��L9�R~K8!�0�@��śd�%h�� �wLJQH��������o5��B��"%�%�pCS��^������L���9��HO��;�{}�f��z����#ݳ {�j2	k��̬�x��O�#�N�)I�\���n�w{D��Z+֋D���9j�Q��w�OK��%�RT��y3�g�& �W��J����v[�T;��i�	�nӛ�Z�5�!�XV�<O��2id�!+����F&�{�:u�f-xWvOa͔Β,���r���w�#�Ix(Uȃ������A�X������ǒ>4q:8���M��" /�OX�Q���A��. �=FnQu AB�D?��}�z7fe\EDb%s��w��y��.��};0��ŋ[ =���l������a�G�6gV��6�/pp�V�NT8���3�+�֭GբX��os �VH��b�g+�^�Ls�1�ƌDob8�ߖC|P��uR5�D������,*�fL;B8}���J��~�Z��ٍ*��}n
kF�]�#���\�O��pr��n�oi��Y�=q:��5�wYu���R洚8@�d�U��+5�C�[Dܓf�|$4*��w��φ�wH�P�Itl���MA�o��|4mZ1��5�\!�Q�: ����m�&�4��5�!.�����l6��\�t��zE�Qd�r�9W������c ��</{�Q/��7������s`��5���JN"�`�ܸ���l1+�.��&!����D{�U?�71�����,��1C@0�3b��5��1 �;8)�G���^;X;>7��w��m���ۜVjN�S��P����ֿ ��ʱ�ȳa�o�m'��=ü��ؤ�_����+���V9}�)+�	��^?_�{݉��\�nt�k-y)���rE�u�|p�}�G�1 ������]n	�v	M�ʂ��=q���P��K��X����כ����|�?-
� 5�r�#�E��jef��F��3+yp��z�4���5�h_5������Aئ���LO��¬
u�a��A��Ҁ������n���Ͷ���$�57x�K撒����@�7#������C<�k�iz8P]<���]��?'J�U���X�?D�б'�H�n��^�xPQ&8�6�u��ϡﰫ����^;89�h!�ږ+@��x�L�Y_��[O�Z�pI���M� mN:��"�a�~:��ր�˸1�5j�5j�Pi�2�/Ծs�v�e����B������K-H�����\�>c9r0 cV"y��Dɬ�پ���Y("��}`��L4L��m�r>p�������F��F����2�������^6A�_����@��>)o�����w�z����'Z⛾�J�u8`8��x��@د���A֯�׮�]�G��^�4
"q��ֵWX�V#�s}���3`�kJ����f�h��n�U�����:�@79���C��o����>������c��M���ǯ��������>>m�<o6}|��n�v�6}����&(������F���� �S�~�����j�U�v�孷�ܹw^���� �`����S h�!f�b:��xH�&$��-�C �_��C����{�MB��Bzҵ�]%bn16\!0�2���0�u��,O�c"
����#�S�4fs(�����TC���:�_sCȡUT���X߱m��G��W<]����Zܯ?#�{{ZD�ոc�n~J�uڰΗ���I�ZA�y�r��!���狦���Q�����2�����P�k{�r�~̶$����ı��冚a�<@�ɟ��G�Z3�����]�(�A%W���[,��+UN��gb��em��)��ꖳ�jJ;���5Ñ��6����S��v��g��kʐj칧F�U�!�a$�|U8l�#�W�n�����H�O��8��\	^�l���@`� ]>>#���p�^�W��6A��c"���sKm���[A����{4��%�]u=��/S���L���/����Ƿ���������f�������ݿ����߃����o�?y|����5��o(���'����O�}u{����t�4�7#H���.&��������.��� ����� "MH >�xD�[��[� �7�, X��7� 	Fw��x�� ����%9�'��X�e���t}|u!3A������1	P���$��˸
>y��*��~~�i?+����k� H��0���Aj�o��@4�K����qufo�_Z��&5�l������3�Az�W�8�ň$�u��M�;Q���"́T�o�n�n�f�:��W20��S]��@ӨD�&����z�$���n&�HϮJ������b:�f���T_�"!���z���d	3nW�������j(����i,
����û�bD�%j9S�/@��0�ѥ}u)�!���/4�_��aEG��DC���8��65�*�i�y-��y�^��!ص��7�4��dp���8|4����:�Cph&t�Ì�a�B� ��������!~|]��A���RO�z��'!�?���:rB_I�6Ҕ�>d���@���p��������h�	�2�'�I$�r�RJ����J�l�M.!
��2LHE�G3*�7�5!%�	'D���:�42�RO�2n���é��"�8a��>��B6��I!�>1��q�Nq�N�%�)]Kg��hp7���"��;;Y�|
�DƊػ:�����;jy��~aMI�q��Jz������M���������80�gNF�m�g�H*�3Sb�4ajE�_��-�I�>#1 *�6*����k�^����˼1��i���������W �;���8�]����޿(/Gt�6r�D�Wc�[.C����Ȉquķ���-k�������������d� �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        