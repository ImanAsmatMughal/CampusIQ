import React, { useState, Suspense, lazy } from 'react';
import { AuthProvider, useAuth } from './context/AuthContext';
import { SettingsProvider } from './context/SettingsContext';
import AppLayout from './layouts/AppLayout';
import SettingsModal from './components/SettingsModal';

// Code-split page modules for instantaneous initial load time
const LoginPage = lazy(() => import('./pages/LoginPage'));
const DashboardPage = lazy(() => import('./pages/DashboardPage'));
const AcademicPage = lazy(() => import('./pages/AcademicPage'));
const InventoryPage = lazy(() => import('./pages/InventoryPage'));
const RequestsPage = lazy(() => import('./pages/RequestsPage'));
const FinancePage = lazy(() => import('./pages/FinancePage'));
const ReportsPage = lazy(() => import('./pages/ReportsPage'));
const AiAssistantPage = lazy(() => import('./pages/AiAssistantPage'));
const HealthDashboard = lazy(() => import('./components/HealthDashboard'));

function PageLoadingFallback() {
  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '60vh',
      gap: '0.85rem'
    }}>
      <div className="pulse-dot" style={{ width: '18px', height: '18px', color: 'var(--primary)' }}></div>
      <span style={{ fontSize: '0.85rem', color: 'var(--text-muted)', fontWeight: 600 }}>Loading module...</span>
    </div>
  );
}

function AuthenticatedApp() {
  const { isAuthenticated, loading } = useAuth();
  const [currentView, setCurrentView] = useState('dashboard');

  if (loading) {
    return (
      <div style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'var(--bg-app)',
        color: 'var(--text-muted)'
      }}>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '1rem' }}>
          <div className="pulse-dot" style={{ width: '16px', height: '16px', color: 'var(--primary)' }}></div>
          <span style={{ fontSize: '0.9rem', fontWeight: 600 }}>Loading CampusIQ Session...</span>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return (
      <Suspense fallback={<PageLoadingFallback />}>
        <LoginPage />
      </Suspense>
    );
  }

  const renderCurrentView = () => {
    switch (currentView) {
      case 'dashboard':
        return <DashboardPage onNavigate={setCurrentView} />;
      case 'academic':
        return <AcademicPage onNavigate={setCurrentView} />;
      case 'inventory':
        return <InventoryPage onNavigate={setCurrentView} />;
      case 'requests':
        return <RequestsPage onNavigate={setCurrentView} />;
      case 'finance':
        return <FinancePage onNavigate={setCurrentView} />;
      case 'reports':
        return <ReportsPage onNavigate={setCurrentView} />;
      case 'ai-assistant':
        return <AiAssistantPage onNavigate={setCurrentView} />;
      case 'health':
        return <HealthDashboard onNavigate={setCurrentView} />;
      default:
        return <DashboardPage onNavigate={setCurrentView} />;
    }
  };

  return (
    <>
      <AppLayout currentView={currentView} onNavigate={setCurrentView}>
        <Suspense fallback={<PageLoadingFallback />}>
          {renderCurrentView()}
        </Suspense>
      </AppLayout>
      <SettingsModal />
    </>
  );
}

export default function App() {
  return (
    <SettingsProvider>
      <AuthProvider>
        <AuthenticatedApp />
      </AuthProvider>
    </SettingsProvider>
  );
}
