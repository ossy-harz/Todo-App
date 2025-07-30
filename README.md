# Todo App Admin Panel

A modern, production-ready admin panel for managing users and tasks in the Todo mobile app.

## Features

- **Dashboard**: Overview of app metrics and user activity
- **User Management**: View, search, and manage user accounts
- **Task Management**: Monitor and manage tasks across all users
- **Gamification**: Track user streaks and badges
- **Real-time Updates**: Live data synchronization with Firebase
- **Responsive Design**: Works on desktop and mobile devices

## Tech Stack

- **Framework**: Next.js 15 with App Router
- **Styling**: Tailwind CSS + shadcn/ui components
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **State Management**: React Context + Hooks
- **Testing**: Jest + React Testing Library
- **CI/CD**: GitHub Actions

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn
- Firebase project with Firestore and Auth enabled

### Installation

1. Clone the repository:
\`\`\`bash
git clone <repository-url>
cd todo-admin-panel
\`\`\`

2. Install dependencies:
\`\`\`bash
npm install
\`\`\`

3. Set up environment variables:
\`\`\`bash
cp .env.example .env.local
\`\`\`

Fill in your Firebase configuration:
\`\`\`
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_auth_domain
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_storage_bucket
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
\`\`\`

4. Run the development server:
\`\`\`bash
npm run dev
\`\`\`

5. Open [http://localhost:3000](http://localhost:3000) in your browser.

### Default Login Credentials

For development/demo purposes:
- Email: `admin@example.com`
- Password: `password`

## Project Structure

\`\`\`
├── app/                    # Next.js App Router pages
│   ├── api/               # API routes
│   ├── dashboard/         # Dashboard pages
│   ├── login/            # Authentication
│   └── globals.css       # Global styles
├── components/            # Reusable components
│   ├── auth/             # Authentication components
│   ├── dashboard/        # Dashboard-specific components
│   ├── layout/           # Layout components
│   ├── providers/        # Context providers
│   ├── tasks/            # Task management components
│   ├── ui/               # shadcn/ui components
│   └── users/            # User management components
├── lib/                  # Utility functions
├── hooks/                # Custom React hooks
└── types/                # TypeScript type definitions
\`\`\`

## Key Features

### Authentication & Authorization
- Firebase Auth integration
- Protected routes with auth guards
- Role-based access control

### Dashboard Analytics
- Real-time user and task statistics
- Activity feed
- Performance metrics
- Gamification tracking

### User Management
- User search and filtering
- Account activation/deactivation
- User profile viewing
- Badge and streak tracking

### Task Management
- Cross-user task viewing
- Advanced search and filtering
- Bulk operations (complete, delete)
- Priority and status management

## Testing

Run the test suite:
\`\`\`bash
npm test
\`\`\`

Run tests in watch mode:
\`\`\`bash
npm run test:watch
\`\`\`

Generate coverage report:
\`\`\`bash
npm run test:coverage
\`\`\`

## Deployment

### Firebase Hosting

1. Install Firebase CLI:
\`\`\`bash
npm install -g firebase-tools
\`\`\`

2. Login to Firebase:
\`\`\`bash
firebase login
\`\`\`

3. Initialize Firebase in your project:
\`\`\`bash
firebase init hosting
\`\`\`

4. Build and deploy:
\`\`\`bash
npm run build
firebase deploy
\`\`\`

### Vercel Deployment

1. Install Vercel CLI:
\`\`\`bash
npm install -g vercel
\`\`\`

2. Deploy:
\`\`\`bash
vercel
\`\`\`

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `NEXT_PUBLIC_FIREBASE_API_KEY` | Firebase API Key | Yes |
| `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` | Firebase Auth Domain | Yes |
| `NEXT_PUBLIC_FIREBASE_PROJECT_ID` | Firebase Project ID | Yes |
| `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET` | Firebase Storage Bucket | Yes |
| `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID` | Firebase Messaging Sender ID | Yes |
| `NEXT_PUBLIC_FIREBASE_APP_ID` | Firebase App ID | Yes |

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
