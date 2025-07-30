# shadcn/ui Integration Guide

## 📋 Overview

This guide provides comprehensive integration instructions for shadcn/ui components with MCP @21st-dev/magic tool integration for enhanced React development workflows.

## 🎯 shadcn/ui Framework Support

### What is shadcn/ui?

shadcn/ui is a collection of reusable components built using Radix UI and Tailwind CSS. It's designed to be:
- **Copy & Paste**: Components you can copy and paste into your apps
- **Customizable**: Fully customizable and extensible
- **Accessible**: Built on Radix UI primitives for accessibility
- **Modern**: Uses the latest React patterns and TypeScript

### Key Features

- **Headless Components**: Built on Radix UI primitives
- **Tailwind CSS**: Styled with Tailwind CSS utility classes
- **TypeScript**: Full TypeScript support with proper type definitions
- **Dark Mode**: Built-in dark mode support
- **Theming**: Comprehensive theming system
- **Responsive**: Mobile-first responsive design

## 🛠️ MCP @21st-dev/magic Integration

### MCP Tool Capabilities

The @21st-dev/magic MCP tool provides:
- **Component Generation**: Generate shadcn/ui components with proper setup
- **Theme Management**: Manage and customize themes programmatically
- **Component Customization**: Modify existing components with variations
- **Template Creation**: Create component templates for reuse
- **Code Analysis**: Analyze component usage and optimization opportunities

### Setup Instructions

1. **Install MCP Tool**
```bash
npm install -g @21st-dev/magic
```

2. **Configure MCP in Project**
```json
// .mcp-config.json
{
  "tools": {
    "@21st-dev/magic": {
      "enabled": true,
      "config": {
        "framework": "react",
        "ui-library": "shadcn/ui",
        "styling": "tailwind",
        "typescript": true
      }
    }
  }
}
```

3. **Initialize shadcn/ui**
```bash
npx shadcn-ui@latest init
```

## 🎨 Component Architecture

### Component Structure

```
src/
├── components/
│   ├── ui/                 # shadcn/ui components
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   └── ...
│   ├── custom/            # Custom components
│   │   ├── data-table.tsx
│   │   ├── form-builder.tsx
│   │   └── ...
│   └── layout/            # Layout components
│       ├── header.tsx
│       ├── sidebar.tsx
│       └── footer.tsx
├── lib/
│   ├── utils.ts           # Utility functions (cn, etc.)
│   └── validations.ts     # Form validation schemas
└── styles/
    └── globals.css        # Global styles and CSS variables
```

### Component Categories

#### Core UI Components
- **Button**: Various button styles and sizes
- **Input**: Form input components with validation
- **Card**: Content containers with headers and footers
- **Dialog**: Modal dialogs and sheets
- **Dropdown**: Dropdown menus and select components
- **Navigation**: Navigation menus and breadcrumbs

#### Data Display
- **Table**: Data tables with sorting and filtering
- **Badge**: Status indicators and labels
- **Avatar**: User profile images and initials
- **Skeleton**: Loading state placeholders
- **Progress**: Progress bars and indicators

#### Form Components
- **Form**: Form wrapper with validation
- **Label**: Form field labels
- **Checkbox**: Checkbox inputs
- **Radio**: Radio button groups
- **Switch**: Toggle switches
- **Textarea**: Multi-line text inputs

#### Layout Components
- **Sheet**: Slide-out panels and drawers
- **Tabs**: Tabbed content organization
- **Accordion**: Collapsible content sections
- **Separator**: Visual content dividers
- **Scroll Area**: Custom scrollable areas

## 🎯 Development Patterns

### Component Creation with MCP

```typescript
// Using MCP @21st-dev/magic to generate components
import { magic } from '@21st-dev/magic';

// Generate a new shadcn/ui component
const component = await magic.generate({
  type: 'component',
  name: 'UserProfile',
  baseComponent: 'card',
  props: {
    user: 'User',
    showActions: 'boolean',
    onEdit: '() => void'
  },
  styling: {
    theme: 'default',
    variant: 'outline'
  }
});
```

### Theme Customization

```css
/* globals.css - CSS Variables for theming */
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96%;
    --secondary-foreground: 222.2 84% 4.9%;
    --muted: 210 40% 96%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96%;
    --accent-foreground: 222.2 84% 4.9%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    /* ... dark mode variables */
  }
}
```

### Utility Functions

```typescript
// lib/utils.ts
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// Form validation with Zod
import { z } from "zod";

export const userSchema = z.object({
  name: z.string().min(2, "Name must be at least 2 characters"),
  email: z.string().email("Invalid email address"),
  age: z.number().min(18, "Must be at least 18 years old"),
});

export type User = z.infer<typeof userSchema>;
```

## 🚀 Integration with BMAD Workflow

### Agent Integration

#### Frontend Developer Agent Enhancement
```yaml
# Enhanced commands for shadcn/ui support
commands:
  - create-shadcn-component: Generate shadcn/ui component with MCP magic
  - customize-theme: Customize theme variables and dark mode
  - optimize-components: Analyze and optimize component usage
  - generate-form: Create form components with validation
  - create-data-table: Generate data table with sorting and filtering
```

#### MCP Tool Integration
```typescript
// Integration with MCP tools in development workflow
interface MCPShadcnIntegration {
  generateComponent(spec: ComponentSpec): Promise<ComponentCode>;
  customizeTheme(theme: ThemeConfig): Promise<CSSVariables>;
  analyzeUsage(project: ProjectStructure): Promise<UsageReport>;
  optimizeBundle(components: ComponentList): Promise<OptimizationSuggestions>;
}
```

### Workflow Integration

1. **Component Planning**: Use MCP to analyze requirements and suggest components
2. **Generation**: Generate base components with proper TypeScript types
3. **Customization**: Apply project-specific styling and behavior
4. **Integration**: Integrate with existing state management and data flow
5. **Testing**: Generate tests for components with proper mocking
6. **Optimization**: Analyze bundle size and optimize imports

## 📋 Best Practices

### Component Development
- **Composition over Inheritance**: Build complex components from simple ones
- **Prop Drilling Avoidance**: Use React Context for deep prop passing
- **TypeScript First**: Always define proper TypeScript interfaces
- **Accessibility**: Ensure all components meet WCAG guidelines
- **Performance**: Use React.memo and useMemo for expensive operations

### Styling Guidelines
- **Utility First**: Use Tailwind utility classes primarily
- **CSS Variables**: Use CSS custom properties for theming
- **Responsive Design**: Mobile-first responsive approach
- **Dark Mode**: Support both light and dark themes
- **Consistent Spacing**: Use consistent spacing scale

### State Management Integration
```typescript
// Integration with state management
interface ComponentWithState {
  // Zustand integration
  useStore: <T>(selector: (state: State) => T) => T;
  
  // React Query integration
  useQuery: <T>(key: string, fetcher: () => Promise<T>) => QueryResult<T>;
  
  // Form state management
  useForm: <T>(schema: ZodSchema<T>) => FormMethods<T>;
}
```

## 🔧 Development Commands

### Component Generation
```bash
# Generate new component with MCP
npx @21st-dev/magic generate component UserCard --base=card --props="user:User,onEdit:()=>void"

# Add shadcn/ui component
npx shadcn-ui@latest add button card dialog

# Customize existing component
npx @21st-dev/magic customize button --variant=ghost --size=lg
```

### Theme Management
```bash
# Generate theme variations
npx @21st-dev/magic theme create --name=corporate --primary="#1a365d"

# Export theme variables
npx @21st-dev/magic theme export --format=css --output=theme.css
```

### Code Analysis
```bash
# Analyze component usage
npx @21st-dev/magic analyze components --report=usage

# Bundle optimization
npx @21st-dev/magic optimize --target=bundle-size --threshold=100kb
```

## 🧪 Testing Strategy

### Component Testing
```typescript
// Component test with shadcn/ui
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from '@/components/ui/button';

describe('Button Component', () => {
  it('renders with correct variant', () => {
    render(<Button variant="destructive">Delete</Button>);
    
    const button = screen.getByRole('button', { name: /delete/i });
    expect(button).toHaveClass('bg-destructive');
  });

  it('handles click events', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

### Visual Testing
```typescript
// Storybook integration for visual testing
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from '@/components/ui/button';

const meta: Meta<typeof Button> = {
  title: 'UI/Button',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    variant: 'default',
    children: 'Button',
  },
};
```

## 🔒 Security Considerations

### Input Validation
- **Sanitization**: Sanitize all user inputs before rendering
- **XSS Prevention**: Use proper escaping for dynamic content
- **CSRF Protection**: Implement CSRF tokens for forms
- **Content Security Policy**: Configure CSP headers properly

### Component Security
- **Prop Validation**: Validate all component props
- **Safe Rendering**: Avoid dangerouslySetInnerHTML
- **Access Control**: Implement proper role-based access
- **Audit Dependencies**: Regular security audits of dependencies

## 📊 Performance Optimization

### Bundle Optimization
- **Tree Shaking**: Import only used components
- **Code Splitting**: Split components into separate bundles
- **Lazy Loading**: Lazy load heavy components
- **Bundle Analysis**: Regular bundle size analysis

### Runtime Performance
- **Memoization**: Use React.memo for expensive components
- **Virtual Scrolling**: For large lists and tables
- **Image Optimization**: Optimize images and use proper formats
- **Caching**: Implement proper caching strategies

This integration guide ensures shadcn/ui is properly integrated into the BMAD framework with full MCP tool support for enhanced development workflows.