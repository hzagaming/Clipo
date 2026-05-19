import Foundation

enum LocKey: String {
    // MARK: - Settings
    case settingsTitle
    case tabGeneral, tabShortcuts, tabClipboard, tabPrivacy, tabData, tabSFX
    case sectionStartup
    case launchAtLoginTitle, launchAtLoginSubtitle
    case showDockIconTitle, showDockIconSubtitle
    case sectionLanguage
    case languageTitle, languageSubtitle
    case sectionAppearance
    case showNotificationsTitle, showNotificationsSubtitle
    case reduceAnimationsTitle, reduceAnimationsSubtitle
    case showEmptySlotsTitle, showEmptySlotsSubtitle
    case sectionGlobalShortcuts
    case openPanelShortcutTitle
    case saveSlotShortcutTitle
    case copySlotShortcutTitle
    case shortcutConflictWarning
    case resetShortcutsButton
    case sectionPasteBehavior
    case restoreAfterPasteTitle, restoreAfterPasteSubtitle
    case restoreAfterSaveTitle, restoreAfterSaveSubtitle
    case sectionHistoryBehavior
    case ignoreDuplicateHistoryTitle, ignoreDuplicateHistorySubtitle
    case pasteOnSelectionTitle, pasteOnSelectionSubtitle
    case sectionStorage
    case maxHistoryItemsTitle
    case autoDeleteUnpinnedTitle
    case currentHistoryTitle
    case currentHistoryCountTemplate
    case sectionAccessibilityPermission
    case accessibilityGranted, accessibilityRequired
    case accessibilityDescription
    case openSystemSettingsButton
    case sectionSecurity
    case ignoreSensitiveAppsTitle, ignoreSensitiveAppsSubtitle
    case sectionSensitiveAppBlacklist
    case noAppsBlacklisted
    case addButton
    case sectionImportExport
    case exportJSON, importJSON, openDataFolder
    case sectionDangerZone
    case clearAllHistory, resetAllSlots, resetAllData
    case alertClearHistoryTitle, alertClearHistoryMessage, alertClearHistoryConfirm
    case alertResetSlotsTitle, alertResetSlotsMessage, alertResetSlotsConfirm
    case alertResetAllTitle, alertResetAllMessage, alertResetAllConfirm
    case alertLaunchAtLoginTitle, alertLaunchAtLoginMessage
    case statusAccessibilityOn, statusAccessibilityOff
    case statusLaunchAtLoginOn, statusLaunchAtLoginOff
    case statusHistoryTemplate
    case statusSlotsTemplate
    
    // MARK: - Panel
    case panelTitle
    case needsPermission
    case settingsTooltip
    case permissionBannerText
    case searchPlaceholder
    case searchNoResults
    case slotsSection
    case recentHistorySection
    case noHistoryTitle
    case noHistorySubtitle
    case onboardingStep1, onboardingStep2, onboardingStep3, onboardingStep4
    case footerSelect, footerCopy, footerPaste, footerPin, footerDelete, footerClose, footerSave
    case contextMenuCopy, contextMenuPaste, contextMenuPin, contextMenuUnpin, contextMenuDelete
    case newSlot
    case saveSlotHintTemplate
    case slotEmptyTemplate
    case slotTitleTemplate
    
    // MARK: - Permission
    case permissionTitle
    case permissionSubtitle
    case permissionMenuBarHint
    case skipForNow
    case permissionStep1, permissionStep2, permissionStep3
    case debugBuildHint
    
    // MARK: - AppDelegate / Menu
    case appNameMenuTitle
    case slotCopyMenuTitle
    case slotPasteMenuTitle
    case recentHistoryMenuTitle
    case noHistoryMenuItem
    case openPanelMenuTitle
    case settingsMenuItem
    case clearHistoryMenuItem
    case resetSlotsMenuItem
    case requestAccessibilityMenuItem
    case accessibilityGrantedMenuItem
    case quitMenuItem
    
    // MARK: - Notifications
    case notificationClipoReadyTitle
    case notificationClipoReadyBody
    case notificationCopiedTitle
    case notificationCopiedBody
    case notificationCopiedImageBody
    case notificationCopiedFileBody
    case notificationCopiedFilesBody
    case notificationCopiedRichTextBody
    case notificationSavedToSlotTemplate
    case notificationSlotEmptyTemplate
    case notificationSlotEmptyBody
    case notificationPermissionRequiredTitle
    case notificationPermissionRequiredBody
    case notificationSensitiveAppIgnoredTitle
    case notificationSensitiveAppIgnoredBody
    case notificationSaveFailedTitle
    case notificationSaveFailedBody
    case notificationHistoryClearedTitle
    case notificationHistoryClearedBody
    case notificationSlotsResetTitle
    case notificationSlotsResetBody
    case notificationPastePermissionTitle
    case notificationPastePermissionBody
    
    // MARK: - Types
    case typeText, typeURL, typeCode, typeImage, typeFile, typeRich, typeData
    
    // MARK: - History / Misc
    case pinnedLabel
    case justNow
    case minutesAgoTemplate
    case hoursAgoTemplate
    case loadingText
    case emptySlot
    case runningTitle
    case runningBody
    case dockEnabledTitle
    case dockEnabledBody
    case dockHiddenTitle
    case dockHiddenBody
    case settingSavedTitle
    case settingSavedBody
    case importSuccessTitle
    case importSuccessBody
    case importSuccessRestartBody
    case exportSuccessTitle
    case exportSuccessBody
    case autoDeleteNever
    case autoDeleteOneDay
    case autoDeleteSevenDays
    case autoDeleteThirtyDays
    case accessibilityWaitingMessage
    case accessibilityRequiredTemplate
    case checkingPermission
    case checkAgainButton
    case allFilter
    case exportFailedTitle
    case exportFailedMessage
    case importFailedTitle
    case importFailedMessage
    case hotkeyRegistrationFailedTitle
    case hotkeyRegistrationFailedTemplate
    case dataResetTitle
    case dataResetBody
    case saveFailedTitle
    case saveFailedBody
    case launchAtLoginFailedBody
    case accessibilityEnabledDescription
    case checkingAccessibilityPermissionMenu
    case customLabel
    case keyCodeTemplate
    
    // MARK: - Sound Effects
    case sectionSoundEffects
    case sfxMasterToggle, sfxMasterToggleSubtitle
    case sfxVolumeTitle
    case sfxCopyToggle
    case sfxPasteToggle
    case sfxSaveToggle
    case sfxOpenToggle
    case sfxCloseToggle
    case sfxErrorToggle
    case sfxResetToggle
    
    // MARK: - Insights Dashboard
    case tabInsights
    case statTodayLabel
    case statWeekLabel
    case statTotalLabel
    case statSourcesLabel
    case trendTitle
    case hourlyTitle
    case peakHourTemplate
    case typeDistTitle
    case topSourcesTitle
    case slotUtilTitle
    case slotUtilTemplate
    case noDataLabel
    case unknownSource
    case todayLabel
    case hourlyStartLabel
    case hourlyEndLabel
    case slotUtilEmptyLabel
    case showSourceAppTitle, showSourceAppSubtitle
    case panelAnimationSpeedTitle, panelAnimationSpeedSubtitle
    case notificationDurationTitle, notificationDurationSubtitle
    case searchCaseSensitiveTitle, searchCaseSensitiveSubtitle
    case pasteDelayTitle, pasteDelaySubtitle
    case okButton
}

struct L10n {
    static func string(_ key: LocKey, _ arguments: CVarArg...) -> String {
        let lang = ClipStore.shared.settings.language.rawValue
        let template = table[key.rawValue]?[lang] ?? table[key.rawValue]?["en"] ?? key.rawValue
        return String(format: template, arguments: arguments)
    }
    
    // MARK: - Translation Table
    
    private static let table: [String: [String: String]] = [
        // Settings
        "settingsTitle": [
            "en": "Clipo Settings",
            "zh-Hans": "Clipo 设置",
            "zh-Hant": "Clipo 設定",
            "ja": "Clipo 設定",
            "ko": "Clipo 설정",
            "fr": "Paramètres Clipo",
            "de": "Clipo Einstellungen",
            "es": "Ajustes de Clipo",
            "ru": "Настройки Clipo",
            "pt": "Configurações do Clipo"
        ],
        "tabGeneral": [
            "en": "General",
            "zh-Hans": "通用",
            "zh-Hant": "一般",
            "ja": "一般",
            "ko": "일반",
            "fr": "Général",
            "de": "Allgemein",
            "es": "General",
            "ru": "Основные",
            "pt": "Geral"
        ],
        "tabShortcuts": [
            "en": "Shortcuts",
            "zh-Hans": "快捷键",
            "zh-Hant": "快捷鍵",
            "ja": "ショートカット",
            "ko": "단축키",
            "fr": "Raccourcis",
            "de": "Tastenkürzel",
            "es": "Atajos",
            "ru": "Горячие клавиши",
            "pt": "Atalhos"
        ],
        "tabClipboard": [
            "en": "Clipboard",
            "zh-Hans": "剪贴板",
            "zh-Hant": "剪貼簿",
            "ja": "クリップボード",
            "ko": "클립보드",
            "fr": "Presse-papiers",
            "de": "Zwischenablage",
            "es": "Portapapeles",
            "ru": "Буфер обмена",
            "pt": "Área de Transferência"
        ],
        "tabPrivacy": [
            "en": "Privacy",
            "zh-Hans": "隐私",
            "zh-Hant": "隱私",
            "ja": "プライバシー",
            "ko": "개인정보 보호",
            "fr": "Confidentialité",
            "de": "Datenschutz",
            "es": "Privacidad",
            "ru": "Конфиденциальность",
            "pt": "Privacidade"
        ],
        "tabData": [
            "en": "Data",
            "zh-Hans": "数据",
            "zh-Hant": "資料",
            "ja": "データ",
            "ko": "데이터",
            "fr": "Données",
            "de": "Daten",
            "es": "Datos",
            "ru": "Данные",
            "pt": "Dados"
        ],
        "tabSFX": [
            "en": "Sound Effects",
            "zh-Hans": "音效",
            "zh-Hant": "音效",
            "ja": "効果音",
            "ko": "효과음",
            "fr": "Effets sonores",
            "de": "Soundeffekte",
            "es": "Efectos de sonido",
            "ru": "Звуковые эффекты",
            "pt": "Efeitos Sonoros"
        ],
        "sectionStartup": [
            "en": "Startup",
            "zh-Hans": "启动",
            "zh-Hant": "啟動",
            "ja": "起動",
            "ko": "시작",
            "fr": "Démarrage",
            "de": "Start",
            "es": "Inicio",
            "ru": "Запуск",
            "pt": "Inicialização"
        ],
        "launchAtLoginTitle": [
            "en": "Launch at Login",
            "zh-Hans": "登录时启动",
            "zh-Hant": "登入時啟動",
            "ja": "ログイン時に起動",
            "ko": "로그인 시 실행",
            "fr": "Lancer à la connexion",
            "de": "Bei Anmeldung starten",
            "es": "Iniciar al entrar",
            "ru": "Запуск при входе",
            "pt": "Iniciar no Login"
        ],
        "launchAtLoginSubtitle": [
            "en": "Start Clipo automatically when you log in",
            "zh-Hans": "登录时自动启动 Clipo",
            "zh-Hant": "登入時自動啟動 Clipo",
            "ja": "ログイン時に自動的に Clipo を起動",
            "ko": "로그인할 때 Clipo 자동 실행",
            "fr": "Démarrer Clipo automatiquement à la connexion",
            "de": "Clipo automatisch bei der Anmeldung starten",
            "es": "Iniciar Clipo automáticamente al entrar",
            "ru": "Автоматически запускать Clipo при входе",
            "pt": "Iniciar o Clipo automaticamente ao fazer login"
        ],
        "showDockIconTitle": [
            "en": "Show Dock Icon",
            "zh-Hans": "显示程序坞图标",
            "zh-Hant": "顯示 Dock 圖示",
            "ja": "Dock アイコンを表示",
            "ko": "Dock 아이콘 표시",
            "fr": "Afficher l'icône dans le Dock",
            "de": "Dock-Symbol anzeigen",
            "es": "Mostrar icono en el Dock",
            "ru": "Показывать значок в Dock",
            "pt": "Mostrar Ícone no Dock"
        ],
        "showDockIconSubtitle": [
            "en": "Display Clipo in the Dock for easy access",
            "zh-Hans": "在程序坞中显示 Clipo 以便快速访问",
            "zh-Hant": "在 Dock 中顯示 Clipo 以便快速存取",
            "ja": "Dock に Clipo を表示して簡単にアクセス",
            "ko": "빠른 접근을 위해 Dock에 Clipo 표시",
            "fr": "Afficher Clipo dans le Dock pour un accès facile",
            "de": "Clipo im Dock anzeigen für einfachen Zugriff",
            "es": "Mostrar Clipo en el Dock para acceso fácil",
            "ru": "Отображать Clipo в Dock для удобного доступа",
            "pt": "Exibir o Clipo no Dock para acesso fácil"
        ],
        "sectionLanguage": [
            "en": "Language",
            "zh-Hans": "语言",
            "zh-Hant": "語言",
            "ja": "言語",
            "ko": "언어",
            "fr": "Langue",
            "de": "Sprache",
            "es": "Idioma",
            "ru": "Язык",
            "pt": "Idioma"
        ],
        "languageTitle": [
            "en": "App Language",
            "zh-Hans": "应用语言",
            "zh-Hant": "應用程式語言",
            "ja": "アプリの言語",
            "ko": "앱 언어",
            "fr": "Langue de l'application",
            "de": "App-Sprache",
            "es": "Idioma de la app",
            "ru": "Язык приложения",
            "pt": "Idioma do App"
        ],
        "languageSubtitle": [
            "en": "Select your preferred display language",
            "zh-Hans": "选择您偏好的显示语言",
            "zh-Hant": "選擇您偏好的顯示語言",
            "ja": "表示言語を選択してください",
            "ko": "선호하는 표시 언어를 선택하세요",
            "fr": "Sélectionnez votre langue d'affichage préférée",
            "de": "Wählen Sie Ihre bevorzugte Anzeigesprache",
            "es": "Seleccione su idioma de visualización preferido",
            "ru": "Выберите предпочитаемый язык отображения",
            "pt": "Selecione seu idioma de exibição preferido"
        ],
        "sectionAppearance": [
            "en": "Appearance",
            "zh-Hans": "外观",
            "zh-Hant": "外觀",
            "ja": "外観",
            "ko": "외관",
            "fr": "Apparence",
            "de": "Erscheinungsbild",
            "es": "Apariencia",
            "ru": "Внешний вид",
            "pt": "Aparência"
        ],
        "showNotificationsTitle": [
            "en": "Show Notifications",
            "zh-Hans": "显示通知",
            "zh-Hant": "顯示通知",
            "ja": "通知を表示",
            "ko": "알림 표시",
            "fr": "Afficher les notifications",
            "de": "Benachrichtigungen anzeigen",
            "es": "Mostrar notificaciones",
            "ru": "Показывать уведомления",
            "pt": "Mostrar notificações"
        ],
        "showNotificationsSubtitle": [
            "en": "Display toast alerts for actions",
            "zh-Hans": "为操作显示弹窗提醒",
            "zh-Hant": "為操作顯示彈窗提醒",
            "ja": "アクションのトースト通知を表示",
            "ko": "작업에 대한 알림 표시",
            "fr": "Afficher les alertes toast pour les actions",
            "de": "Toast-Benachrichtigungen für Aktionen anzeigen",
            "es": "Mostrar alertas toast para acciones",
            "ru": "Показывать тост-уведомления для действий",
            "pt": "Exibir alertas toast para ações"
        ],
        "reduceAnimationsTitle": [
            "en": "Reduce Animations",
            "zh-Hans": "减少动画",
            "zh-Hant": "減少動畫",
            "ja": "アニメーションを減らす",
            "ko": "애니메이션 줄이기",
            "fr": "Réduire les animations",
            "de": "Animationen reduzieren",
            "es": "Reducir animaciones",
            "ru": "Уменьшить анимации",
            "pt": "Reduzir animações"
        ],
        "reduceAnimationsSubtitle": [
            "en": "Disable motion effects for accessibility",
            "zh-Hans": "为无障碍访问禁用动效",
            "zh-Hant": "為無障礙存取停用動效",
            "ja": "アクセシビリティのためモーション効果を無効化",
            "ko": "접근성을 위해 모션 효과 비활성화",
            "fr": "Désactiver les effets de mouvement pour l'accessibilité",
            "de": "Bewegungseffekte für Barrierefreiheit deaktivieren",
            "es": "Deshabilitar efectos de movimiento para accesibilidad",
            "ru": "Отключить эффекты движения для доступности",
            "pt": "Desativar efeitos de movimento para acessibilidade"
        ],
        "showEmptySlotsTitle": [
            "en": "Show Empty Slots",
            "zh-Hans": "显示空槽位",
            "zh-Hant": "顯示空槽位",
            "ja": "空のスロットを表示",
            "ko": "빈 슬롯 표시",
            "fr": "Afficher les emplacements vides",
            "de": "Leere Slots anzeigen",
            "es": "Mostrar ranuras vacías",
            "ru": "Показывать пустые слоты",
            "pt": "Mostrar slots vazios"
        ],
        "showEmptySlotsSubtitle": [
            "en": "Display placeholder rows for unused slots",
            "zh-Hans": "为未使用的槽位显示占位行",
            "zh-Hant": "為未使用的槽位顯示佔位行",
            "ja": "未使用スロットのプレースホルダーを表示",
            "ko": "사용되지 않은 슬롯에 대한 자리 표시자 표시",
            "fr": "Afficher les lignes d'espace réservé pour les emplacements inutilisés",
            "de": "Platzhalterzeilen für unbenutzte Slots anzeigen",
            "es": "Mostrar filas de marcador de posición para ranuras no utilizadas",
            "ru": "Показывать строки-заполнители для неиспользуемых слотов",
            "pt": "Exibir linhas de espaço reservado para slots não utilizados"
        ],
        "sectionGlobalShortcuts": [
            "en": "Global Shortcuts",
            "zh-Hans": "全局快捷键",
            "zh-Hant": "全域快捷鍵",
            "ja": "グローバルショートカット",
            "ko": "전역 단축키",
            "fr": "Raccourcis globaux",
            "de": "Globale Tastenkürzel",
            "es": "Atajos globales",
            "ru": "Глобальные горячие клавиши",
            "pt": "Atalhos Globais"
        ],
        "openPanelShortcutTitle": [
            "en": "Open Clipo Panel",
            "zh-Hans": "打开 Clipo 面板",
            "zh-Hant": "打開 Clipo 面板",
            "ja": "Clipo パネルを開く",
            "ko": "Clipo 패널 열기",
            "fr": "Ouvrir le panneau Clipo",
            "de": "Clipo-Panel öffnen",
            "es": "Abrir panel de Clipo",
            "ru": "Открыть панель Clipo",
            "pt": "Abrir Painel do Clipo"
        ],
        "saveSlotShortcutTitle": [
            "en": "Save to Slot 1–9",
            "zh-Hans": "保存到槽位 1–9",
            "zh-Hant": "儲存到槽位 1–9",
            "ja": "スロット 1–9 に保存",
            "ko": "슬롯 1–9에 저장",
            "fr": "Enregistrer dans l'emplacement 1–9",
            "de": "In Slot 1–9 speichern",
            "es": "Guardar en ranura 1–9",
            "ru": "Сохранить в слот 1–9",
            "pt": "Salvar no Slot 1–9"
        ],
        "copySlotShortcutTitle": [
            "en": "Copy Slot to Clipboard",
            "zh-Hans": "复制槽位到剪贴板",
            "zh-Hant": "複製槽位到剪貼簿",
            "ja": "スロットをクリップボードにコピー",
            "ko": "슬롯을 클립보드에 복사",
            "fr": "Copier l'emplacement dans le presse-papiers",
            "de": "Slot in Zwischenablage kopieren",
            "es": "Copiar ranura al portapapeles",
            "ru": "Копировать слот в буфер обмена",
            "pt": "Copiar Slot para Área de Transferência"
        ],
        "shortcutConflictWarning": [
            "en": "Save and Copy modifiers are identical — slot shortcuts will conflict.",
            "zh-Hans": "保存和复制的修饰键相同 — 槽位快捷键将发生冲突。",
            "zh-Hant": "儲存和複製的修飾鍵相同 — 槽位快捷鍵將發生衝突。",
            "ja": "保存とコピーの修飾キーが同じです — スロットショートカットが競合します。",
            "ko": "저장 및 복사 수정자가 동일함 — 슬롯 단축키가 충돌합니다.",
            "fr": "Les modificateurs Enregistrer et Copier sont identiques — les raccourcis d'emplacement entreront en conflit.",
            "de": "Speichern- und Kopieren-Modifikatoren sind identisch — Slot-Tastenkürzel kollidieren.",
            "es": "Los modificadores de Guardar y Copiar son idénticos — los atajos de ranura entrarán en conflicto.",
            "ru": "Модификаторы Сохранить и Копировать идентичны — горячие клавиши слотов будут конфликтовать.",
            "pt": "Os modificadores de Salvar e Copiar são idênticos — os atalhos de slot entrarão em conflito."
        ],
        "resetShortcutsButton": [
            "en": "Reset Shortcuts to Default",
            "zh-Hans": "重置快捷键为默认",
            "zh-Hant": "重置快捷鍵為預設",
            "ja": "ショートカットをデフォルトにリセット",
            "ko": "단축키를 기본값으로 재설정",
            "fr": "Rétablir les raccourcis par défaut",
            "de": "Tastenkürzel auf Standard zurücksetzen",
            "es": "Restablecer atajos por defecto",
            "ru": "Сбросить горячие клавиши по умолчанию",
            "pt": "Redefinir Atalhos para o Padrão"
        ],
        "sectionPasteBehavior": [
            "en": "Paste Behavior",
            "zh-Hans": "粘贴行为",
            "zh-Hant": "貼上行為",
            "ja": "貼り付けの動作",
            "ko": "붙여넣기 동작",
            "fr": "Comportement du collage",
            "de": "Einfügeverhalten",
            "es": "Comportamiento de pegado",
            "ru": "Поведение вставки",
            "pt": "Comportamento de Colar"
        ],
        "restoreAfterPasteTitle": [
            "en": "Restore Clipboard After Pasting",
            "zh-Hans": "粘贴后恢复剪贴板",
            "zh-Hant": "貼上後恢復剪貼簿",
            "ja": "貼り付け後にクリップボードを復元",
            "ko": "붙여넣기 후 클립보드 복원",
            "fr": "Restaurer le presse-papiers après le collage",
            "de": "Zwischenablage nach dem Einfügen wiederherstellen",
            "es": "Restaurar portapapeles después de pegar",
            "ru": "Восстановить буфер обмена после вставки",
            "pt": "Restaurar Área de Transferência após Colar"
        ],
        "restoreAfterPasteSubtitle": [
            "en": "Return previous clipboard content after a paste operation",
            "zh-Hans": "粘贴操作后恢复之前的剪贴板内容",
            "zh-Hant": "貼上操作後恢復之前的剪貼簿內容",
            "ja": "貼り付け操作後に前のクリップボード内容を復元",
            "ko": "붙여넣기 작업 후 이전 클립보드 내용 복원",
            "fr": "Restaurer le contenu précédent du presse-papiers après une opération de collage",
            "de": "Vorherigen Zwischenablageinhalt nach dem Einfügen wiederherstellen",
            "es": "Restaurar el contenido anterior del portapapeles después de pegar",
            "ru": "Вернуть предыдущее содержимое буфера обмена после вставки",
            "pt": "Restaurar o conteúdo anterior da área de transferência após colar"
        ],
        "restoreAfterSaveTitle": [
            "en": "Restore Clipboard After Saving",
            "zh-Hans": "保存后恢复剪贴板",
            "zh-Hant": "儲存後恢復剪貼簿",
            "ja": "保存後にクリップボードを復元",
            "ko": "저장 후 클립보드 복원",
            "fr": "Restaurer le presse-papiers après l'enregistrement",
            "de": "Zwischenablage nach dem Speichern wiederherstellen",
            "es": "Restaurar portapapeles después de guardar",
            "ru": "Восстановить буфер обмена после сохранения",
            "pt": "Restaurar Área de Transferência após Salvar"
        ],
        "restoreAfterSaveSubtitle": [
            "en": "Return previous clipboard content after saving to a slot",
            "zh-Hans": "保存到槽位后恢复之前的剪贴板内容",
            "zh-Hant": "儲存到槽位後恢復之前的剪貼簿內容",
            "ja": "スロットに保存後に前のクリップボード内容を復元",
            "ko": "슬롯에 저장 후 이전 클립보드 내용 복원",
            "fr": "Restaurer le contenu précédent du presse-papiers après l'enregistrement dans un emplacement",
            "de": "Vorherigen Zwischenablageinhalt nach dem Speichern in einem Slot wiederherstellen",
            "es": "Restaurar el contenido anterior del portapapeles después de guardar en una ranura",
            "ru": "Вернуть предыдущее содержимое буфера обмена после сохранения в слот",
            "pt": "Restaurar o conteúdo anterior da área de transferência após salvar em um slot"
        ],
        "sectionHistoryBehavior": [
            "en": "History Behavior",
            "zh-Hans": "历史行为",
            "zh-Hant": "歷史行為",
            "ja": "履歴の動作",
            "ko": "기록 동작",
            "fr": "Comportement de l'historique",
            "de": "Verlaufsverhalten",
            "es": "Comportamiento del historial",
            "ru": "Поведение истории",
            "pt": "Comportamento do histórico"
        ],
        "ignoreDuplicateHistoryTitle": [
            "en": "Ignore Duplicate History",
            "zh-Hans": "忽略重复历史",
            "zh-Hant": "忽略重複歷史",
            "ja": "重複履歴を無視",
            "ko": "중복 기록 무시",
            "fr": "Ignorer les doublons dans l'historique",
            "de": "Doppelte Verlaufseinträge ignorieren",
            "es": "Ignorar historial duplicado",
            "ru": "Игнорировать дубликаты в истории",
            "pt": "Ignorar histórico duplicado"
        ],
        "ignoreDuplicateHistorySubtitle": [
            "en": "Skip recording the same content twice in a row",
            "zh-Hans": "跳过连续记录相同内容",
            "zh-Hant": "跳過連續記錄相同內容",
            "ja": "同じ内容を連続して記録しない",
            "ko": "동일한 내용을 연속으로 기록하지 않음",
            "fr": "Ne pas enregistrer deux fois le même contenu consécutivement",
            "de": "Gleiche Inhalte nicht zweimal hintereinander aufzeichnen",
            "es": "Omitir registrar el mismo contenido dos veces seguidas",
            "ru": "Не записывать одинаковое содержимое дважды подряд",
            "pt": "Pular o registro do mesmo conteúdo duas vezes seguidas"
        ],
        "pasteOnSelectionTitle": [
            "en": "Paste on Selection",
            "zh-Hans": "选中即粘贴",
            "zh-Hant": "選中即貼上",
            "ja": "選択時に貼り付け",
            "ko": "선택 시 붙여넣기",
            "fr": "Coller lors de la sélection",
            "de": "Bei Auswahl einfügen",
            "es": "Pegar al seleccionar",
            "ru": "Вставлять при выборе",
            "pt": "Colar ao selecionar"
        ],
        "pasteOnSelectionSubtitle": [
            "en": "Press Return to paste instead of copy",
            "zh-Hans": "按回车键粘贴而非复制",
            "zh-Hant": "按回車鍵貼上而非複製",
            "ja": "Returnキーでコピーではなく貼り付け",
            "ko": "Return 키로 복사 대신 붙여넣기",
            "fr": "Appuyez sur Retour pour coller au lieu de copier",
            "de": "Drücken Sie Return zum Einfügen statt Kopieren",
            "es": "Presione Retorno para pegar en lugar de copiar",
            "ru": "Нажмите Return для вставки вместо копирования",
            "pt": "Pressione Return para colar em vez de copiar"
        ],
        "sectionStorage": [
            "en": "Storage",
            "zh-Hans": "存储",
            "zh-Hant": "儲存",
            "ja": "ストレージ",
            "ko": "저장",
            "fr": "Stockage",
            "de": "Speicher",
            "es": "Almacenamiento",
            "ru": "Хранилище",
            "pt": "Armazenamento"
        ],
        "maxHistoryItemsTitle": [
            "en": "Max History Items",
            "zh-Hans": "最大历史条目数",
            "zh-Hant": "最大歷史項目數",
            "ja": "最大履歴項目数",
            "ko": "최대 기록 항목 수",
            "fr": "Nombre max d'éléments d'historique",
            "de": "Max. Verlaufselemente",
            "es": "Máx. de elementos del historial",
            "ru": "Макс. элементов истории",
            "pt": "Máx. de Itens do Histórico"
        ],
        "autoDeleteUnpinnedTitle": [
            "en": "Auto Delete Unpinned",
            "zh-Hans": "自动删除未置顶",
            "zh-Hant": "自動刪除未置頂",
            "ja": "未固定項目を自動削除",
            "ko": "고정되지 않은 항목 자동 삭제",
            "fr": "Suppression auto des non-épinglés",
            "de": "Ungepinnte automatisch löschen",
            "es": "Eliminar automáticamente no fijados",
            "ru": "Автоудаление незакреплённых",
            "pt": "Excluir Automaticamente Não Fixados"
        ],
        "currentHistoryTitle": [
            "en": "Current History",
            "zh-Hans": "当前历史",
            "zh-Hant": "目前歷史",
            "ja": "現在の履歴",
            "ko": "현재 기록",
            "fr": "Historique actuel",
            "de": "Aktueller Verlauf",
            "es": "Historial actual",
            "ru": "Текущая история",
            "pt": "Histórico Atual"
        ],
        "currentHistoryCountTemplate": [
            "en": "%d items",
            "zh-Hans": "%d 条",
            "zh-Hant": "%d 項",
            "ja": "%d 項目",
            "ko": "%d개 항목",
            "fr": "%d éléments",
            "de": "%d Elemente",
            "es": "%d elementos",
            "ru": "%d элементов",
            "pt": "%d itens"
        ],
        "sectionAccessibilityPermission": [
            "en": "Accessibility Permission",
            "zh-Hans": "辅助功能权限",
            "zh-Hant": "輔助使用權限",
            "ja": "アクセシビリティ権限",
            "ko": "손쉬운 사용 권한",
            "fr": "Permission d'accessibilité",
            "de": "Bedienungshilfen-Berechtigung",
            "es": "Permiso de accesibilidad",
            "ru": "Разрешение специальных возможностей",
            "pt": "Permissão de Acessibilidade"
        ],
        "accessibilityGranted": [
            "en": "Granted",
            "zh-Hans": "已授权",
            "zh-Hant": "已授權",
            "ja": "許可済み",
            "ko": "허용됨",
            "fr": "Accordé",
            "de": "Gewährt",
            "es": "Concedido",
            "ru": "Предоставлено",
            "pt": "Concedida"
        ],
        "accessibilityRequired": [
            "en": "Required",
            "zh-Hans": "需要授权",
            "zh-Hant": "需要授權",
            "ja": "必要",
            "ko": "필요함",
            "fr": "Requis",
            "de": "Erforderlich",
            "es": "Requerido",
            "ru": "Требуется",
            "pt": "Necessária"
        ],
        "accessibilityDescription": [
            "en": "Clipo needs Accessibility permission to simulate Command+C when saving selected text.",
            "zh-Hans": "Clipo 需要辅助功能权限来模拟 Command+C 以保存所选文本。",
            "zh-Hant": "Clipo 需要輔助使用權限來模擬 Command+C 以儲存所選文字。",
            "ja": "Clipo は選択したテキストを保存するために Command+C をシミュレートするため、アクセシビリティ権限が必要です。",
            "ko": "Clipo는 선택한 텍스트를 저장할 때 Command+C를 시뮬레이션하기 위해 손쉬운 사용 권한이 필요합니다.",
            "fr": "Clipo a besoin de la permission d'accessibilité pour simuler Command+C lors de l'enregistrement du texte sélectionné.",
            "de": "Clipo benötigt die Bedienungshilfen-Berechtigung, um beim Speichern des markierten Textes Command+C zu simulieren.",
            "es": "Clipo necesita permiso de accesibilidad para simular Comando+C al guardar el texto seleccionado.",
            "ru": "Clipo требуется разрешение специальных возможностей для имитации Command+C при сохранении выделенного текста.",
            "pt": "O Clipo precisa de permissão de Acessibilidade para simular Command+C ao salvar o texto selecionado."
        ],
        "openSystemSettingsButton": [
            "en": "Open System Settings",
            "zh-Hans": "打开系统设置",
            "zh-Hant": "打開系統設定",
            "ja": "システム設定を開く",
            "ko": "시스템 설정 열기",
            "fr": "Ouvrir les paramètres système",
            "de": "Systemeinstellungen öffnen",
            "es": "Abrir Ajustes del Sistema",
            "ru": "Открыть Настройки системы",
            "pt": "Abrir Configurações do Sistema"
        ],
        "sectionSecurity": [
            "en": "Security",
            "zh-Hans": "安全",
            "zh-Hant": "安全性",
            "ja": "セキュリティ",
            "ko": "보안",
            "fr": "Sécurité",
            "de": "Sicherheit",
            "es": "Seguridad",
            "ru": "Безопасность",
            "pt": "Segurança"
        ],
        "ignoreSensitiveAppsTitle": [
            "en": "Ignore Sensitive Apps",
            "zh-Hans": "忽略敏感应用",
            "zh-Hant": "忽略敏感應用程式",
            "ja": "機密アプリを無視",
            "ko": "민감한 앱 무시",
            "fr": "Ignorer les apps sensibles",
            "de": "Sensitive Apps ignorieren",
            "es": "Ignorar apps sensibles",
            "ru": "Игнорировать конфиденциальные приложения",
            "pt": "Ignorar Apps Sensíveis"
        ],
        "ignoreSensitiveAppsSubtitle": [
            "en": "Do not save clipboard content from password managers",
            "zh-Hans": "不保存来自密码管理器的剪贴板内容",
            "zh-Hant": "不儲存來自密碼管理器的剪貼簿內容",
            "ja": "パスワードマネージャーのクリップボード内容を保存しない",
            "ko": "비밀번호 관리자의 클립보드 내용을 저장하지 않음",
            "fr": "Ne pas enregistrer le contenu du presse-papiers des gestionnaires de mots de passe",
            "de": "Zwischenablage-Inhalte von Passwort-Managern nicht speichern",
            "es": "No guardar contenido del portapapeles de administradores de contraseñas",
            "ru": "Не сохранять содержимое буфера обмена из менеджеров паролей",
            "pt": "Não salvar conteúdo da área de transferência de gerenciadores de senhas"
        ],
        "sectionSensitiveAppBlacklist": [
            "en": "Sensitive App Blacklist",
            "zh-Hans": "敏感应用黑名单",
            "zh-Hant": "敏感應用程式黑名單",
            "ja": "機密アプリのブラックリスト",
            "ko": "민감한 앱 블랙리스트",
            "fr": "Liste noire des apps sensibles",
            "de": "Blacklist sensibler Apps",
            "es": "Lista negra de apps sensibles",
            "ru": "Чёрный список конфиденциальных приложений",
            "pt": "Lista Negra de Apps Sensíveis"
        ],
        "noAppsBlacklisted": [
            "en": "No apps blacklisted",
            "zh-Hans": "没有应用被列入黑名单",
            "zh-Hant": "沒有應用程式被列入黑名單",
            "ja": "ブラックリストにアプリはありません",
            "ko": "블랙리스트에 앱 없음",
            "fr": "Aucune app en liste noire",
            "de": "Keine Apps auf der Blacklist",
            "es": "Ninguna app en lista negra",
            "ru": "Нет приложений в чёрном списке",
            "pt": "Nenhum app na lista negra"
        ],
        "addButton": [
            "en": "Add",
            "zh-Hans": "添加",
            "zh-Hant": "加入",
            "ja": "追加",
            "ko": "추가",
            "fr": "Ajouter",
            "de": "Hinzufügen",
            "es": "Añadir",
            "ru": "Добавить",
            "pt": "Adicionar"
        ],
        "sectionImportExport": [
            "en": "Import / Export",
            "zh-Hans": "导入 / 导出",
            "zh-Hant": "匯入 / 匯出",
            "ja": "インポート / エクスポート",
            "ko": "가져오기 / 내보내기",
            "fr": "Importer / Exporter",
            "de": "Importieren / Exportieren",
            "es": "Importar / Exportar",
            "ru": "Импорт / Экспорт",
            "pt": "Importar / Exportar"
        ],
        "exportJSON": [
            "en": "Export JSON",
            "zh-Hans": "导出 JSON",
            "zh-Hant": "匯出 JSON",
            "ja": "JSON をエクスポート",
            "ko": "JSON 내보내기",
            "fr": "Exporter JSON",
            "de": "JSON exportieren",
            "es": "Exportar JSON",
            "ru": "Экспорт JSON",
            "pt": "Exportar JSON"
        ],
        "importJSON": [
            "en": "Import JSON",
            "zh-Hans": "导入 JSON",
            "zh-Hant": "匯入 JSON",
            "ja": "JSON をインポート",
            "ko": "JSON 가져오기",
            "fr": "Importer JSON",
            "de": "JSON importieren",
            "es": "Importar JSON",
            "ru": "Импорт JSON",
            "pt": "Importar JSON"
        ],
        "openDataFolder": [
            "en": "Open Data Folder",
            "zh-Hans": "打开数据文件夹",
            "zh-Hant": "打開資料夾",
            "ja": "データフォルダを開く",
            "ko": "데이터 폴더 열기",
            "fr": "Ouvrir le dossier de données",
            "de": "Datenordner öffnen",
            "es": "Abrir carpeta de datos",
            "ru": "Открыть папку данных",
            "pt": "Abrir Pasta de Dados"
        ],
        "sectionDangerZone": [
            "en": "Danger Zone",
            "zh-Hans": "危险区域",
            "zh-Hant": "危險區域",
            "ja": "危険な操作",
            "ko": "위험 구역",
            "fr": "Zone dangereuse",
            "de": "Gefahrenzone",
            "es": "Zona de peligro",
            "ru": "Опасная зона",
            "pt": "Zona de Perigo"
        ],
        "clearAllHistory": [
            "en": "Clear All History",
            "zh-Hans": "清除所有历史",
            "zh-Hant": "清除所有歷史",
            "ja": "すべての履歴をクリア",
            "ko": "모든 기록 지우기",
            "fr": "Effacer tout l'historique",
            "de": "Gesamten Verlauf löschen",
            "es": "Borrar todo el historial",
            "ru": "Очистить всю историю",
            "pt": "Limpar Todo o Histórico"
        ],
        "resetAllSlots": [
            "en": "Reset All Slots",
            "zh-Hans": "重置所有槽位",
            "zh-Hant": "重置所有槽位",
            "ja": "すべてのスロットをリセット",
            "ko": "모든 슬롯 재설정",
            "fr": "Réinitialiser tous les emplacements",
            "de": "Alle Slots zurücksetzen",
            "es": "Restablecer todas las ranuras",
            "ru": "Сбросить все слоты",
            "pt": "Redefinir Todos os Slots"
        ],
        "resetAllData": [
            "en": "Reset All Data",
            "zh-Hans": "重置所有数据",
            "zh-Hant": "重置所有資料",
            "ja": "すべてのデータをリセット",
            "ko": "모든 데이터 재설정",
            "fr": "Réinitialiser toutes les données",
            "de": "Alle Daten zurücksetzen",
            "es": "Restablecer todos los datos",
            "ru": "Сбросить все данные",
            "pt": "Redefinir Todos os Dados",
        ],
        "alertClearHistoryTitle": [
            "en": "Clear History",
            "zh-Hans": "清除历史",
            "zh-Hant": "清除歷史",
            "ja": "履歴をクリア",
            "ko": "기록 지우기",
            "fr": "Effacer l'historique",
            "de": "Verlauf löschen",
            "es": "Borrar historial",
            "ru": "Очистить историю",
            "pt": "Limpar Histórico"
        ],
        "alertClearHistoryMessage": [
            "en": "This will remove all unpinned history items. Pinned items and slots will remain.",
            "zh-Hans": "这将删除所有未置顶的历史条目。置顶项目和槽位将保留。",
            "zh-Hant": "這將刪除所有未置頂的歷史項目。置頂項目和槽位將保留。",
            "ja": "これにより、固定されていない履歴項目がすべて削除されます。固定された項目とスロットは残ります。",
            "ko": "이 작업은 고정되지 않은 모든 기록 항목을 제거합니다. 고정된 항목과 슬롯은 유지됩니다.",
            "fr": "Cela supprimera tous les éléments d'historique non épinglés. Les éléments épinglés et les emplacements resteront.",
            "de": "Dies entfernt alle nicht angehefteten Verlaufselemente. Angeheftete Elemente und Slots bleiben erhalten.",
            "es": "Esto eliminará todos los elementos del historial no fijados. Los elementos fijados y las ranuras permanecerán.",
            "ru": "Это удалит все незакреплённые элементы истории. Закреплённые элементы и слоты останутся.",
            "pt": "Isso removerá todos os itens do histórico não fixados. Itens fixados e slots permanecerão."
        ],
        "alertClearHistoryConfirm": [
            "en": "Clear",
            "zh-Hans": "清除",
            "zh-Hant": "清除",
            "ja": "クリア",
            "ko": "지우기",
            "fr": "Effacer",
            "de": "Löschen",
            "es": "Borrar",
            "ru": "Очистить",
            "pt": "Limpar"
        ],
        "alertResetSlotsTitle": [
            "en": "Reset Slots",
            "zh-Hans": "重置槽位",
            "zh-Hant": "重置槽位",
            "ja": "スロットをリセット",
            "ko": "슬롯 재설정",
            "fr": "Réinitialiser les emplacements",
            "de": "Slots zurücksetzen",
            "es": "Restablecer ranuras",
            "ru": "Сбросить слоты",
            "pt": "Redefinir Slots"
        ],
        "alertResetSlotsMessage": [
            "en": "This will clear all 9 slots. History will remain.",
            "zh-Hans": "这将清空所有 9 个槽位。历史记录将保留。",
            "zh-Hant": "這將清空所有 9 個槽位。歷史記錄將保留。",
            "ja": "これにより、すべての 9 つのスロットがクリアされます。履歴は残ります。",
            "ko": "이 작업은 모든 9개 슬롯을 비웁니다. 기록은 유지됩니다.",
            "fr": "Cela effacera les 9 emplacements. L'historique restera.",
            "de": "Dies löscht alle 9 Slots. Der Verlauf bleibt erhalten.",
            "es": "Esto borrará las 9 ranuras. El historial permanecerá.",
            "ru": "Это очистит все 9 слотов. История останется.",
            "pt": "Isso limpará todos os 9 slots. O histórico permanecerá."
        ],
        "alertResetSlotsConfirm": [
            "en": "Reset",
            "zh-Hans": "重置",
            "zh-Hant": "重置",
            "ja": "リセット",
            "ko": "재설정",
            "fr": "Réinitialiser",
            "de": "Zurücksetzen",
            "es": "Restablecer",
            "ru": "Сбросить",
            "pt": "Redefinir"
        ],
        "alertResetAllTitle": [
            "en": "Reset All Data",
            "zh-Hans": "重置所有数据",
            "zh-Hant": "重置所有資料",
            "ja": "すべてのデータをリセット",
            "ko": "모든 데이터 재설정",
            "fr": "Réinitialiser toutes les données",
            "de": "Alle Daten zurücksetzen",
            "es": "Restablecer todos los datos",
            "ru": "Сбросить все данные",
            "pt": "Redefinir Todos os Dados"
        ],
        "alertResetAllMessage": [
            "en": "This will erase all slots, history, and settings. This action cannot be undone.",
            "zh-Hans": "这将清除所有槽位、历史记录和设置。此操作无法撤销。",
            "zh-Hant": "這將清除所有槽位、歷史記錄和設定。此操作無法復原。",
            "ja": "これにより、すべてのスロット、履歴、設定が消去されます。この操作は元に戻せません。",
            "ko": "이 작업은 모든 슬롯, 기록 및 설정을 지웁니다. 이 작업은 취소할 수 없습니다.",
            "fr": "Cela effacera tous les emplacements, l'historique et les paramètres. Cette action est irréversible.",
            "de": "Dies löscht alle Slots, den Verlauf und die Einstellungen. Diese Aktion kann nicht rückgängig gemacht werden.",
            "es": "Esto borrará todas las ranuras, el historial y la configuración. Esta acción no se puede deshacer.",
            "ru": "Это сотрёт все слоты, историю и настройки. Это действие нельзя отменить.",
            "pt": "Isso apagará todos os slots, histórico e configurações. Esta ação não pode ser desfeita."
        ],
        "alertResetAllConfirm": [
            "en": "Erase Everything",
            "zh-Hans": "全部擦除",
            "zh-Hant": "全部擦除",
            "ja": "すべて消去",
            "ko": "모두 지우기",
            "fr": "Tout effacer",
            "de": "Alles löschen",
            "es": "Borrar todo",
            "ru": "Стереть всё",
            "pt": "Apagar Tudo"
        ],
        "alertLaunchAtLoginTitle": [
            "en": "Launch at Login Failed",
            "zh-Hans": "登录启动失败",
            "zh-Hant": "登入啟動失敗",
            "ja": "ログイン時起動に失敗",
            "ko": "로그인 시 실행 실패",
            "fr": "Échec du lancement à la connexion",
            "de": "Start bei Anmeldung fehlgeschlagen",
            "es": "Error al iniciar al entrar",
            "ru": "Не удалось запустить при входе",
            "pt": "Falha ao Iniciar no Login"
        ],
        "alertLaunchAtLoginMessage": [
            "en": "This feature requires the app to be code-signed. Please sign the app with your Apple Developer ID or disable this setting.",
            "zh-Hans": "此功能需要应用经过代码签名。请使用您的 Apple Developer ID 签名应用或禁用此设置。",
            "zh-Hant": "此功能需要應用程式經過程式碼簽署。請使用您的 Apple Developer ID 簽署應用程式或停用此設定。",
            "ja": "この機能にはアプリのコード署名が必要です。Apple Developer ID で署名するか、この設定を無効にしてください。",
            "ko": "이 기능은 앱이 코드 서명되어 있어야 합니다. Apple Developer ID로 서명하거나 이 설정을 비활성화하세요.",
            "fr": "Cette fonctionnalité nécessite que l'app soit signée. Veuillez signer l'app avec votre Apple Developer ID ou désactiver ce paramètre.",
            "de": "Diese Funktion erfordert, dass die App code-signiert ist. Bitte signieren Sie die App mit Ihrer Apple Developer ID oder deaktivieren Sie diese Einstellung.",
            "es": "Esta función requiere que la app esté firmada. Firme la app con su Apple Developer ID o desactive esta configuración.",
            "ru": "Эта функция требует подписи кода приложения. Подпишите приложение своим Apple Developer ID или отключите эту настройку.",
            "pt": "Este recurso exige que o app seja assinado. Assine o app com seu Apple Developer ID ou desative esta configuração."
        ],
        "statusAccessibilityOn": [
            "en": "Accessibility On",
            "zh-Hans": "辅助功能已开启",
            "zh-Hant": "輔助使用已開啟",
            "ja": "アクセシビリティ ON",
            "ko": "손쉬운 사용 켜짐",
            "fr": "Accessibilité activée",
            "de": "Bedienungshilfen an",
            "es": "Accesibilidad activada",
            "ru": "Спец. возможности вкл.",
            "pt": "Acessibilidade Ativada"
        ],
        "statusAccessibilityOff": [
            "en": "Accessibility Off",
            "zh-Hans": "辅助功能已关闭",
            "zh-Hant": "輔助使用已關閉",
            "ja": "アクセシビリティ OFF",
            "ko": "손쉬운 사용 꺼짐",
            "fr": "Accessibilité désactivée",
            "de": "Bedienungshilfen aus",
            "es": "Accesibilidad desactivada",
            "ru": "Спец. возможности выкл.",
            "pt": "Acessibilidade Desativada"
        ],
        "statusLaunchAtLoginOn": [
            "en": "Launch at Login On",
            "zh-Hans": "登录启动已开启",
            "zh-Hant": "登入啟動已開啟",
            "ja": "ログイン時起動 ON",
            "ko": "로그인 시 실행 켜짐",
            "fr": "Lancer à la connexion activé",
            "de": "Start bei Anmeldung an",
            "es": "Iniciar al entrar activado",
            "ru": "Запуск при входе вкл.",
            "pt": "Iniciar no Login Ativado"
        ],
        "statusLaunchAtLoginOff": [
            "en": "Launch at Login Off",
            "zh-Hans": "登录启动已关闭",
            "zh-Hant": "登入啟動已關閉",
            "ja": "ログイン時起動 OFF",
            "ko": "로그인 시 실행 꺼짐",
            "fr": "Lancer à la connexion désactivé",
            "de": "Start bei Anmeldung aus",
            "es": "Iniciar al entrar desactivado",
            "ru": "Запуск при входе выкл.",
            "pt": "Iniciar no Login Desativado"
        ],
        "statusHistoryTemplate": [
            "en": "%d History",
            "zh-Hans": "%d 条历史",
            "zh-Hant": "%d 項歷史",
            "ja": "%d 件の履歴",
            "ko": "기록 %d개",
            "fr": "%d Historique",
            "de": "%d Verlauf",
            "es": "%d Historial",
            "ru": "История: %d",
            "pt": "%d Histórico"
        ],
        "statusSlotsTemplate": [
            "en": "%d/9 Slots",
            "zh-Hans": "%d/9 槽位",
            "zh-Hant": "%d/9 槽位",
            "ja": "%d/9 スロット",
            "ko": "슬롯 %d/9",
            "fr": "%d/9 Emplacements",
            "de": "%d/9 Slots",
            "es": "%d/9 Ranuras",
            "ru": "Слоты: %d/9",
            "pt": "%d/9 Slots"
        ],
        "panelTitle": [
            "en": "Clipo",
            "zh-Hans": "Clipo",
            "zh-Hant": "Clipo",
            "ja": "Clipo",
            "ko": "Clipo",
            "fr": "Clipo",
            "de": "Clipo",
            "es": "Clipo",
            "ru": "Clipo",
            "pt": "Clipo"
        ],
        "needsPermission": [
            "en": "Needs Permission",
            "zh-Hans": "需要权限",
            "zh-Hant": "需要權限",
            "ja": "権限が必要",
            "ko": "권한 필요",
            "fr": "Permission requise",
            "de": "Berechtigung erforderlich",
            "es": "Permiso necesario",
            "ru": "Требуется разрешение",
            "pt": "Permissão Necessária"
        ],
        "settingsTooltip": [
            "en": "Settings",
            "zh-Hans": "设置",
            "zh-Hant": "設定",
            "ja": "設定",
            "ko": "설정",
            "fr": "Paramètres",
            "de": "Einstellungen",
            "es": "Ajustes",
            "ru": "Настройки",
            "pt": "Configurações"
        ],
        "permissionBannerText": [
            "en": "Accessibility permission is required to save selected text.",
            "zh-Hans": "需要辅助功能权限才能保存所选文本。",
            "zh-Hant": "需要輔助使用權限才能儲存所選文字。",
            "ja": "選択したテキストを保存するにはアクセシビリティ権限が必要です。",
            "ko": "선택한 텍스트를 저장하려면 손쉬운 사용 권한이 필요합니다.",
            "fr": "La permission d'accessibilité est requise pour enregistrer le texte sélectionné.",
            "de": "Die Bedienungshilfen-Berechtigung ist erforderlich, um den markierten Text zu speichern.",
            "es": "Se requiere permiso de accesibilidad para guardar el texto seleccionado.",
            "ru": "Для сохранения выделенного текста требуется разрешение специальных возможностей.",
            "pt": "A permissão de Acessibilidade é necessária para salvar o texto selecionado."
        ],
        "searchPlaceholder": [
            "en": "Search clips...",
            "zh-Hans": "搜索剪贴...",
            "zh-Hant": "搜尋剪貼...",
            "ja": "クリップを検索...",
            "ko": "클립 검색...",
            "fr": "Rechercher des clips...",
            "de": "Clips suchen...",
            "es": "Buscar clips...",
            "ru": "Поиск клипов...",
            "pt": "Pesquisar clips..."
        ],
        "searchNoResults": [
            "en": "No matching results",
            "zh-Hans": "无匹配结果",
            "zh-Hant": "無匹配結果",
            "ja": "一致する結果がありません",
            "ko": "일치하는 결과 없음",
            "fr": "Aucun résultat correspondant",
            "de": "Keine passenden Ergebnisse",
            "es": "Sin resultados coincidentes",
            "ru": "Нет совпадающих результатов",
            "pt": "Nenhum resultado correspondente"
        ],
        "slotsSection": [
            "en": "Slots",
            "zh-Hans": "槽位",
            "zh-Hant": "槽位",
            "ja": "スロット",
            "ko": "슬롯",
            "fr": "Emplacements",
            "de": "Slots",
            "es": "Ranuras",
            "ru": "Слоты",
            "pt": "Slots"
        ],
        "recentHistorySection": [
            "en": "Recent History",
            "zh-Hans": "最近历史",
            "zh-Hant": "最近歷史",
            "ja": "最近の履歴",
            "ko": "최근 기록",
            "fr": "Historique récent",
            "de": "Kürzlicher Verlauf",
            "es": "Historial reciente",
            "ru": "Недавняя история",
            "pt": "Histórico Recente"
        ],
        "noHistoryTitle": [
            "en": "No history yet",
            "zh-Hans": "暂无历史",
            "zh-Hant": "暫無歷史",
            "ja": "まだ履歴がありません",
            "ko": "아직 기록 없음",
            "fr": "Pas encore d'historique",
            "de": "Noch kein Verlauf",
            "es": "Aún no hay historial",
            "ru": "История пока пуста",
            "pt": "Sem histórico ainda"
        ],
        "noHistorySubtitle": [
            "en": "Copy text, images, or files and Clipo will back them up here",
            "zh-Hans": "复制文本、图片或文件，Clipo 将在此备份它们",
            "zh-Hant": "複製文字、圖片或檔案，Clipo 將在此備份它們",
            "ja": "テキスト、画像、またはファイルをコピーすると、Clipo がここにバックアップします",
            "ko": "텍스트, 이미지 또는 파일을 복사하면 Clipo가 여기에 백업합니다",
            "fr": "Copiez du texte, des images ou des fichiers et Clipo les sauvegardera ici",
            "de": "Kopieren Sie Text, Bilder oder Dateien und Clipo sichert sie hier",
            "es": "Copie texto, imágenes o archivos y Clipo los respaldará aquí",
            "ru": "Копируйте текст, изображения или файлы, и Clipo сохранит их здесь",
            "pt": "Copie texto, imagens ou arquivos e o Clipo fará backup deles aqui"
        ],
        "onboardingStep1": [
            "en": "Copy anything in any app",
            "zh-Hans": "在任何应用中复制任何内容",
            "zh-Hant": "在任何應用程式中複製任何內容",
            "ja": "どのアプリでも何でもコピー",
            "ko": "어떤 앱에서든 무엇이든 복사",
            "fr": "Copiez n'importe quoi dans n'importe quelle app",
            "de": "Kopieren Sie in beliebigen Apps beliebige Inhalte",
            "es": "Copie cualquier cosa en cualquier app",
            "ru": "Копируйте что угодно в любом приложении",
            "pt": "Copie qualquer coisa em qualquer app"
        ],
        "onboardingStep2": [
            "en": "Click + New Slot or press ⌘⌥1–9 to save selection",
            "zh-Hans": "点击 + 新槽位或按 ⌘⌥1–9 保存所选内容",
            "zh-Hant": "點擊 + 新槽位或按 ⌘⌥1–9 儲存所選內容",
            "ja": "+ 新規スロットをクリックするか ⌘⌥1–9 を押して選択を保存",
            "ko": "+ 새 슬롯을 클릭하거나 ⌘⌥1–9를 눌러 선택 항목 저장",
            "fr": "Cliquez sur + Nouvel emplacement ou appuyez sur ⌘⌥1–9 pour enregistrer la sélection",
            "de": "Klicken Sie auf + Neuer Slot oder drücken Sie ⌘⌥1–9, um die Auswahl zu speichern",
            "es": "Haga clic en + Nueva ranura o presione ⌘⌥1–9 para guardar la selección",
            "ru": "Нажмите + Новый слот или ⌘⌥1–9, чтобы сохранить выделенное",
            "pt": "Clique em + Novo Slot ou pressione ⌘⌥1–9 para salvar a seleção"
        ],
        "onboardingStep3": [
            "en": "Press ⌥1–9 to copy a slot",
            "zh-Hans": "按 ⌥1–9 复制槽位",
            "zh-Hant": "按 ⌥1–9 複製槽位",
            "ja": "⌥1–9 を押してスロットをコピー",
            "ko": "⌥1–9를 눌러 슬롯 복사",
            "fr": "Appuyez sur ⌥1–9 pour copier un emplacement",
            "de": "Drücken Sie ⌥1–9, um einen Slot zu kopieren",
            "es": "Presione ⌥1–9 para copiar una ranura",
            "ru": "Нажмите ⌥1–9, чтобы скопировать слот",
            "pt": "Pressione ⌥1–9 para copiar um slot"
        ],
        "onboardingStep4": [
            "en": "Press ⌥Space to open Clipo",
            "zh-Hans": "按 ⌥Space 打开 Clipo",
            "zh-Hant": "按 ⌥Space 打開 Clipo",
            "ja": "⌥Space を押して Clipo を開く",
            "ko": "⌥Space를 눌러 Clipo 열기",
            "fr": "Appuyez sur ⌥Espace pour ouvrir Clipo",
            "de": "Drücken Sie ⌥Leertaste, um Clipo zu öffnen",
            "es": "Presione ⌥Espacio para abrir Clipo",
            "ru": "Нажмите ⌥Пробел, чтобы открыть Clipo",
            "pt": "Pressione ⌥Espaço para abrir o Clipo"
        ],
        "footerSelect": [
            "en": "Select",
            "zh-Hans": "选择",
            "zh-Hant": "選擇",
            "ja": "選択",
            "ko": "선택",
            "fr": "Sélectionner",
            "de": "Auswählen",
            "es": "Seleccionar",
            "ru": "Выбрать",
            "pt": "Selecionar"
        ],
        "footerCopy": [
            "en": "Copy",
            "zh-Hans": "复制",
            "zh-Hant": "複製",
            "ja": "コピー",
            "ko": "복사",
            "fr": "Copier",
            "de": "Kopieren",
            "es": "Copiar",
            "ru": "Копировать",
            "pt": "Copiar"
        ],
        "footerPaste": [
            "en": "Paste",
            "zh-Hans": "粘贴",
            "zh-Hant": "貼上",
            "ja": "貼り付け",
            "ko": "붙여넣기",
            "fr": "Coller",
            "de": "Einfügen",
            "es": "Pegar",
            "ru": "Вставить",
            "pt": "Colar"
        ],
        "footerPin": [
            "en": "Pin",
            "zh-Hans": "置顶",
            "zh-Hant": "置頂",
            "ja": "固定",
            "ko": "고정",
            "fr": "Épingler",
            "de": "Anheften",
            "es": "Fijar",
            "ru": "Закрепить",
            "pt": "Fixar"
        ],
        "footerDelete": [
            "en": "Delete",
            "zh-Hans": "删除",
            "zh-Hant": "刪除",
            "ja": "削除",
            "ko": "삭제",
            "fr": "Supprimer",
            "de": "Löschen",
            "es": "Eliminar",
            "ru": "Удалить",
            "pt": "Excluir"
        ],
        "footerClose": [
            "en": "Close",
            "zh-Hans": "关闭",
            "zh-Hant": "關閉",
            "ja": "閉じる",
            "ko": "닫기",
            "fr": "Fermer",
            "de": "Schließen",
            "es": "Cerrar",
            "ru": "Закрыть",
            "pt": "Fechar"
        ],
        "footerSave": [
            "en": "Save",
            "zh-Hans": "保存",
            "zh-Hant": "儲存",
            "ja": "保存",
            "ko": "저장",
            "fr": "Enregistrer",
            "de": "Speichern",
            "es": "Guardar",
            "ru": "Сохранить",
            "pt": "Salvar"
        ],
        "contextMenuCopy": [
            "en": "Copy",
            "zh-Hans": "复制",
            "zh-Hant": "複製",
            "ja": "コピー",
            "ko": "복사",
            "fr": "Copier",
            "de": "Kopieren",
            "es": "Copiar",
            "ru": "Копировать",
            "pt": "Copiar"
        ],
        "contextMenuPaste": [
            "en": "Paste",
            "zh-Hans": "粘贴",
            "zh-Hant": "貼上",
            "ja": "貼り付け",
            "ko": "붙여넣기",
            "fr": "Coller",
            "de": "Einfügen",
            "es": "Pegar",
            "ru": "Вставить",
            "pt": "Colar"
        ],
        "contextMenuPin": [
            "en": "Pin",
            "zh-Hans": "置顶",
            "zh-Hant": "置頂",
            "ja": "固定",
            "ko": "고정",
            "fr": "Épingler",
            "de": "Anheften",
            "es": "Fijar",
            "ru": "Закрепить",
            "pt": "Fixar"
        ],
        "contextMenuUnpin": [
            "en": "Unpin",
            "zh-Hans": "取消置顶",
            "zh-Hant": "取消置頂",
            "ja": "固定解除",
            "ko": "고정 해제",
            "fr": "Désépingler",
            "de": "Lösen",
            "es": "Desfijar",
            "ru": "Открепить",
            "pt": "Desfixar"
        ],
        "contextMenuDelete": [
            "en": "Delete",
            "zh-Hans": "删除",
            "zh-Hant": "刪除",
            "ja": "削除",
            "ko": "삭제",
            "fr": "Supprimer",
            "de": "Löschen",
            "es": "Eliminar",
            "ru": "Удалить",
            "pt": "Excluir"
        ],
        "newSlot": [
            "en": "New Slot",
            "zh-Hans": "新槽位",
            "zh-Hant": "新槽位",
            "ja": "新規スロット",
            "ko": "새 슬롯",
            "fr": "Nouvel emplacement",
            "de": "Neuer Slot",
            "es": "Nueva ranura",
            "ru": "Новый слот",
            "pt": "Novo Slot"
        ],
        "saveSlotHintTemplate": [
            "en": "Click or press ⌘⌥%d to save current selection",
            "zh-Hans": "点击或按 ⌘⌥%d 保存当前所选内容",
            "zh-Hant": "點擊或按 ⌘⌥%d 儲存目前所選內容",
            "ja": "クリックするか ⌘⌥%d を押して現在の選択を保存",
            "ko": "클릭하거나 ⌘⌥%d를 눌러 현재 선택 항목 저장",
            "fr": "Cliquez ou appuyez sur ⌘⌥%d pour enregistrer la sélection actuelle",
            "de": "Klicken Sie oder drücken Sie ⌘⌥%d, um die aktuelle Auswahl zu speichern",
            "es": "Haga clic o presione ⌘⌥%d para guardar la selección actual",
            "ru": "Нажмите или ⌘⌥%d, чтобы сохранить текущее выделенное",
            "pt": "Clique ou pressione ⌘⌥%d para salvar a seleção atual"
        ],
        "slotEmptyTemplate": [
            "en": "Slot %d: Empty",
            "zh-Hans": "槽位 %d：空",
            "zh-Hant": "槽位 %d：空",
            "ja": "スロット %d：空",
            "ko": "슬롯 %d: 비어 있음",
            "fr": "Emplacement %d : Vide",
            "de": "Slot %d: Leer",
            "es": "Ranura %d: Vacía",
            "ru": "Слот %d: Пусто",
            "pt": "Slot %d: Vazio"
        ],
        "slotTitleTemplate": [
            "en": "Slot %d: %@",
            "zh-Hans": "槽位 %d：%@",
            "zh-Hant": "槽位 %d：%@",
            "ja": "スロット %d：%@",
            "ko": "슬롯 %d: %@",
            "fr": "Emplacement %d : %@",
            "de": "Slot %d: %@",
            "es": "Ranura %d: %@",
            "ru": "Слот %d: %@",
            "pt": "Slot %d: %@"
        ],
        "permissionTitle": [
            "en": "Accessibility Permission",
            "zh-Hans": "辅助功能权限",
            "zh-Hant": "輔助使用權限",
            "ja": "アクセシビリティ権限",
            "ko": "손쉬운 사용 권한",
            "fr": "Permission d'accessibilité",
            "de": "Bedienungshilfen-Berechtigung",
            "es": "Permiso de accesibilidad",
            "ru": "Разрешение специальных возможностей",
            "pt": "Permissão de Acessibilidade"
        ],
        "permissionSubtitle": [
            "en": "Required to save selected text with global shortcuts.",
            "zh-Hans": "使用全局快捷键保存所选文本时需要。",
            "zh-Hant": "使用全域快捷鍵儲存所選文字時需要。",
            "ja": "グローバルショートカットで選択したテキストを保存するために必要です。",
            "ko": "전역 단축키로 선택한 텍스트를 저장하려면 필요합니다.",
            "fr": "Requis pour enregistrer le texte sélectionné avec les raccourcis globaux.",
            "de": "Erforderlich, um markierten Text mit globalen Tastenkürzeln zu speichern.",
            "es": "Requerido para guardar el texto seleccionado con atajos globales.",
            "ru": "Требуется для сохранения выделенного текста с помощью глобальных горячих клавиш.",
            "pt": "Necessário para salvar o texto selecionado com atalhos globais."
        ],
        "permissionMenuBarHint": [
            "en": "Clipo lives in your menu bar — look for the clipboard icon.",
            "zh-Hans": "Clipo 位于您的菜单栏中 — 寻找剪贴板图标。",
            "zh-Hant": "Clipo 位於您的選單列中 — 尋找剪貼簿圖示。",
            "ja": "Clipo はメニューバーにあります — クリップボードアイコンを探してください。",
            "ko": "Clipo는 메뉴 표시줄에 있습니다 — 클립보드 아이콘을 찾아보세요.",
            "fr": "Clipo vit dans votre barre de menus — recherchez l'icône du presse-papiers.",
            "de": "Clipo befindet sich in Ihrer Menüleiste — suchen Sie das Clipboard-Symbol.",
            "es": "Clipo vive en su barra de menús — busque el icono del portapapeles.",
            "ru": "Clipo находится в строке меню — найдите значок буфера обмена.",
            "pt": "O Clipo fica na sua barra de menus — procure o ícone da área de transferência."
        ],
        "skipForNow": [
            "en": "Skip for now",
            "zh-Hans": "暂时跳过",
            "zh-Hant": "暫時跳過",
            "ja": "今はスキップ",
            "ko": "일단 건너뛰기",
            "fr": "Passer pour l'instant",
            "de": "Vorerst überspringen",
            "es": "Omitir por ahora",
            "ru": "Пропустить пока",
            "pt": "Pular por enquanto"
        ],
        "permissionStep1": [
            "en": "1. Open System Settings → Privacy & Security → Accessibility",
            "zh-Hans": "1. 打开系统设置 → 隐私与安全性 → 辅助功能",
            "zh-Hant": "1. 打開系統設定 → 隱私權與安全性 → 輔助使用",
            "ja": "1. システム設定を開く → プライバシーとセキュリティ → アクセシビリティ",
            "ko": "1. 시스템 설정 열기 → 개인정보 보호 및 보안 → 손쉬운 사용",
            "fr": "1. Ouvrir les paramètres système → Confidentialité et sécurité → Accessibilité",
            "de": "1. Systemeinstellungen öffnen → Datenschutz & Sicherheit → Bedienungshilfen",
            "es": "1. Abrir Ajustes del Sistema → Privacidad y seguridad → Accesibilidad",
            "ru": "1. Открыть Настройки системы → Конфиденциальность и безопасность → Спец. возможности",
            "pt": "1. Abrir Configurações do Sistema → Privacidade e Segurança → Acessibilidade"
        ],
        "permissionStep2": [
            "en": "2. Add Clipo to the list and enable the checkbox",
            "zh-Hans": "2. 将 Clipo 添加到列表并勾选启用",
            "zh-Hant": "2. 將 Clipo 加入列表並啟用勾選框",
            "ja": "2. Clipo をリストに追加し、チェックボックスを有効にする",
            "ko": "2. Clipo를 목록에 추가하고 확인란을 활성화",
            "fr": "2. Ajoutez Clipo à la liste et cochez la case",
            "de": "2. Fügen Sie Clipo zur Liste hinzu und aktivieren Sie das Kontrollkästchen",
            "es": "2. Agregue Clipo a la lista y active la casilla",
            "ru": "2. Добавьте Clipo в список и включите флажок",
            "pt": "2. Adicione o Clipo à lista e marque a caixa de seleção"
        ],
        "permissionStep3": [
            "en": "3. The app will detect it and continue automatically",
            "zh-Hans": "3. 应用将自动检测并继续",
            "zh-Hant": "3. 應用程式將自動偵測並繼續",
            "ja": "3. アプリが自動的に検出して続行します",
            "ko": "3. 앱이 자동으로 감지하고 계속 진행합니다",
            "fr": "3. L'app le détectera et continuera automatiquement",
            "de": "3. Die App erkennt es und fährt automatisch fort",
            "es": "3. La app lo detectará y continuará automáticamente",
            "ru": "3. Приложение обнаружит это и продолжит автоматически",
            "pt": "3. O app detectará e continuará automaticamente"
        ],
        "debugBuildHint": [
            "en": "Debug build: if permission is already on but not working, remove the old Clipo entry in Accessibility and re-add the current build.",
            "zh-Hans": "调试版本：如果权限已开启但无效，请在辅助功能中删除旧的 Clipo 条目并重新添加当前构建。",
            "zh-Hant": "除錯版本：如果權限已開啟但無效，請在輔助使用中刪除舊的 Clipo 項目並重新加入目前構建。",
            "ja": "デバッグビルド：権限がオンになっているのに動作しない場合は、アクセシビリティから古い Clipo エントリを削除して、現在のビルドを再追加してください。",
            "ko": "디버그 빌드: 권한이 켜져 있지만 작동하지 않는 경우, 손쉬운 사용에서 이전 Clipo 항목을 제거하고 현재 빌드를 다시 추가하세요.",
            "fr": "Build de debug : si la permission est déjà activée mais ne fonctionne pas, supprimez l'ancienne entrée Clipo dans Accessibilité et rajoutez le build actuel.",
            "de": "Debug-Build: Wenn die Berechtigung bereits aktiviert ist, aber nicht funktioniert, entfernen Sie den alten Clipo-Eintrag in Bedienungshilfen und fügen Sie den aktuellen Build erneut hinzu.",
            "es": "Compilación de debug: si el permiso ya está activado pero no funciona, elimine la entrada antigua de Clipo en Accesibilidad y vuelva a agregar la compilación actual.",
            "ru": "Отладочная сборка: если разрешение уже включено, но не работает, удалите старую запись Clipo в спец. возможностях и добавьте текущую сборку заново.",
            "pt": "Build de debug: se a permissão já estiver ativada, mas não funcionar, remova a entrada antiga do Clipo em Acessibilidade e readicione o build atual."
        ],
        "appNameMenuTitle": [
            "en": "Clipo",
            "zh-Hans": "Clipo",
            "zh-Hant": "Clipo",
            "ja": "Clipo",
            "ko": "Clipo",
            "fr": "Clipo",
            "de": "Clipo",
            "es": "Clipo",
            "ru": "Clipo",
            "pt": "Clipo"
        ],
        "slotCopyMenuTitle": [
            "en": "Copy to Clipboard",
            "zh-Hans": "复制到剪贴板",
            "zh-Hant": "複製到剪貼簿",
            "ja": "クリップボードにコピー",
            "ko": "클립보드에 복사",
            "fr": "Copier dans le presse-papiers",
            "de": "In Zwischenablage kopieren",
            "es": "Copiar al portapapeles",
            "ru": "Копировать в буфер обмена",
            "pt": "Copiar para Área de Transferência"
        ],
        "slotPasteMenuTitle": [
            "en": "Paste",
            "zh-Hans": "粘贴",
            "zh-Hant": "貼上",
            "ja": "貼り付け",
            "ko": "붙여넣기",
            "fr": "Coller",
            "de": "Einfügen",
            "es": "Pegar",
            "ru": "Вставить",
            "pt": "Colar"
        ],
        "recentHistoryMenuTitle": [
            "en": "Recent History",
            "zh-Hans": "最近历史",
            "zh-Hant": "最近歷史",
            "ja": "最近の履歴",
            "ko": "최근 기록",
            "fr": "Historique récent",
            "de": "Kürzlicher Verlauf",
            "es": "Historial reciente",
            "ru": "Недавняя история",
            "pt": "Histórico Recente"
        ],
        "noHistoryMenuItem": [
            "en": "No history",
            "zh-Hans": "没有历史",
            "zh-Hant": "沒有歷史",
            "ja": "履歴なし",
            "ko": "기록 없음",
            "fr": "Pas d'historique",
            "de": "Kein Verlauf",
            "es": "Sin historial",
            "ru": "Нет истории",
            "pt": "Sem histórico"
        ],
        "openPanelMenuTitle": [
            "en": "Open Clipo Panel",
            "zh-Hans": "打开 Clipo 面板",
            "zh-Hant": "打開 Clipo 面板",
            "ja": "Clipo パネルを開く",
            "ko": "Clipo 패널 열기",
            "fr": "Ouvrir le panneau Clipo",
            "de": "Clipo-Panel öffnen",
            "es": "Abrir panel de Clipo",
            "ru": "Открыть панель Clipo",
            "pt": "Abrir Painel do Clipo"
        ],
        "settingsMenuItem": [
            "en": "Settings...",
            "zh-Hans": "设置...",
            "zh-Hant": "設定...",
            "ja": "設定...",
            "ko": "설정...",
            "fr": "Paramètres...",
            "de": "Einstellungen...",
            "es": "Ajustes...",
            "ru": "Настройки...",
            "pt": "Configurações..."
        ],
        "clearHistoryMenuItem": [
            "en": "Clear History",
            "zh-Hans": "清除历史",
            "zh-Hant": "清除歷史",
            "ja": "履歴をクリア",
            "ko": "기록 지우기",
            "fr": "Effacer l'historique",
            "de": "Verlauf löschen",
            "es": "Borrar historial",
            "ru": "Очистить историю",
            "pt": "Limpar Histórico"
        ],
        "resetSlotsMenuItem": [
            "en": "Reset Slots",
            "zh-Hans": "重置槽位",
            "zh-Hant": "重置槽位",
            "ja": "スロットをリセット",
            "ko": "슬롯 재설정",
            "fr": "Réinitialiser les emplacements",
            "de": "Slots zurücksetzen",
            "es": "Restablecer ranuras",
            "ru": "Сбросить слоты",
            "pt": "Redefinir Slots"
        ],
        "requestAccessibilityMenuItem": [
            "en": "Request Accessibility Permission…",
            "zh-Hans": "请求辅助功能权限…",
            "zh-Hant": "請求輔助使用權限…",
            "ja": "アクセシビリティ権限を要求…",
            "ko": "손쉬운 사용 권한 요청…",
            "fr": "Demander la permission d'accessibilité…",
            "de": "Bedienungshilfen-Berechtigung anfordern…",
            "es": "Solicitar permiso de accesibilidad…",
            "ru": "Запросить разрешение спец. возможностей…",
            "pt": "Solicitar Permissão de Acessibilidade…"
        ],
        "accessibilityGrantedMenuItem": [
            "en": "Accessibility Permission Granted",
            "zh-Hans": "辅助功能权限已授予",
            "zh-Hant": "輔助使用權限已授予",
            "ja": "アクセシビリティ権限が許可されました",
            "ko": "손쉬운 사용 권한이 부여됨",
            "fr": "Permission d'accessibilité accordée",
            "de": "Bedienungshilfen-Berechtigung erteilt",
            "es": "Permiso de accesibilidad concedido",
            "ru": "Разрешение спец. возможностей предоставлено",
            "pt": "Permissão de Acessibilidade Concedida"
        ],
        "quitMenuItem": [
            "en": "Quit",
            "zh-Hans": "退出",
            "zh-Hant": "結束",
            "ja": "終了",
            "ko": "종료",
            "fr": "Quitter",
            "de": "Beenden",
            "es": "Salir",
            "ru": "Выйти",
            "pt": "Sair"
        ],
        "notificationClipoReadyTitle": [
            "en": "Clipo Ready",
            "zh-Hans": "Clipo 已就绪",
            "zh-Hant": "Clipo 就緒",
            "ja": "Clipo の準備完了",
            "ko": "Clipo 준비 완료",
            "fr": "Clipo prêt",
            "de": "Clipo bereit",
            "es": "Clipo listo",
            "ru": "Clipo готов",
            "pt": "Clipo Pronto"
        ],
        "notificationClipoReadyBody": [
            "en": "Accessibility permission granted. Hotkeys are now active.",
            "zh-Hans": "辅助功能权限已授予。快捷键现已激活。",
            "zh-Hant": "輔助使用權限已授予。快捷鍵現已啟用。",
            "ja": "アクセシビリティ権限が許可されました。ホットキーが有効になりました。",
            "ko": "손쉬운 사용 권한이 부여되었습니다. 단축키가 활성화되었습니다.",
            "fr": "Permission d'accessibilité accordée. Les raccourcis sont maintenant actifs.",
            "de": "Bedienungshilfen-Berechtigung erteilt. Tastenkürzel sind jetzt aktiv.",
            "es": "Permiso de accesibilidad concedido. Los atajos están activos.",
            "ru": "Разрешение спец. возможностей предоставлено. Горячие клавиши активны.",
            "pt": "Permissão de Acessibilidade concedida. Os atalhos estão ativos."
        ],
        "notificationCopiedTitle": [
            "en": "Copied",
            "zh-Hans": "已复制",
            "zh-Hant": "已複製",
            "ja": "コピーしました",
            "ko": "복사됨",
            "fr": "Copié",
            "de": "Kopiert",
            "es": "Copiado",
            "ru": "Скопировано",
            "pt": "Copiado"
        ],
        "notificationCopiedBody": [
            "en": "Press Command+V to paste it anywhere.",
            "zh-Hans": "按 Command+V 粘贴到任意位置。",
            "zh-Hant": "按 Command+V 貼到任意位置。",
            "ja": "Command+V を押してどこにでも貼り付けます。",
            "ko": "Command+V를 눌러 어디에나 붙여넣으세요.",
            "fr": "Appuyez sur Commande+V pour le coller n'importe où.",
            "de": "Drücken Sie Befehl+V, um es überall einzufügen.",
            "es": "Presione Comando+V para pegarlo en cualquier lugar.",
            "ru": "Нажмите Command+V, чтобы вставить в любом месте.",
            "pt": "Pressione Command+V para colar em qualquer lugar."
        ],
        "notificationCopiedImageBody": [
            "en": "Image",
            "zh-Hans": "图片",
            "zh-Hant": "圖片",
            "ja": "画像",
            "ko": "이미지",
            "fr": "Image",
            "de": "Bild",
            "es": "Imagen",
            "ru": "Изображение",
            "pt": "Imagem"
        ],
        "notificationCopiedFileBody": [
            "en": "File: %@",
            "zh-Hans": "文件: %@",
            "zh-Hant": "檔案: %@",
            "ja": "ファイル: %@",
            "ko": "파일: %@",
            "fr": "Fichier: %@",
            "de": "Datei: %@",
            "es": "Archivo: %@",
            "ru": "Файл: %@",
            "pt": "Arquivo: %@"
        ],
        "notificationCopiedFilesBody": [
            "en": "%d Files",
            "zh-Hans": "%d 个文件",
            "zh-Hant": "%d 個檔案",
            "ja": "%d ファイル",
            "ko": "%d개 파일",
            "fr": "%d fichiers",
            "de": "%d Dateien",
            "es": "%d archivos",
            "ru": "%d файлов",
            "pt": "%d arquivos"
        ],
        "notificationCopiedRichTextBody": [
            "en": "Rich Text",
            "zh-Hans": "富文本",
            "zh-Hant": "富文字",
            "ja": "リッチテキスト",
            "ko": "서식 있는 텍스트",
            "fr": "Texte enrichi",
            "de": "Rich Text",
            "es": "Texto enriquecido",
            "ru": "Форматированный текст",
            "pt": "Texto Rico"
        ],
        "notificationSavedToSlotTemplate": [
            "en": "Saved to Slot %d",
            "zh-Hans": "已保存到槽位 %d",
            "zh-Hant": "已儲存到槽位 %d",
            "ja": "スロット %d に保存しました",
            "ko": "슬롯 %d에 저장됨",
            "fr": "Enregistré dans l'emplacement %d",
            "de": "In Slot %d gespeichert",
            "es": "Guardado en ranura %d",
            "ru": "Сохранено в слот %d",
            "pt": "Salvo no Slot %d"
        ],
        "notificationSlotEmptyTemplate": [
            "en": "Slot %d Empty",
            "zh-Hans": "槽位 %d 为空",
            "zh-Hant": "槽位 %d 為空",
            "ja": "スロット %d は空です",
            "ko": "슬롯 %d 비어 있음",
            "fr": "Emplacement %d vide",
            "de": "Slot %d leer",
            "es": "Ranura %d vacía",
            "ru": "Слот %d пуст",
            "pt": "Slot %d Vazio"
        ],
        "notificationSlotEmptyBody": [
            "en": "Nothing has been saved to this slot yet.",
            "zh-Hans": "此槽位尚未保存任何内容。",
            "zh-Hant": "此槽位尚未儲存任何內容。",
            "ja": "このスロットにはまだ何も保存されていません。",
            "ko": "이 슬롯에 아직 저장된 내용이 없습니다.",
            "fr": "Aucun élément n'a encore été enregistré dans cet emplacement.",
            "de": "In diesem Slot wurde noch nichts gespeichert.",
            "es": "Aún no se ha guardado nada en esta ranura.",
            "ru": "В этом слоте ещё ничего не сохранено.",
            "pt": "Nada foi salvo neste slot ainda."
        ],
        "notificationPermissionRequiredTitle": [
            "en": "Permission Required",
            "zh-Hans": "需要权限",
            "zh-Hant": "需要權限",
            "ja": "権限が必要",
            "ko": "권한 필요",
            "fr": "Permission requise",
            "de": "Berechtigung erforderlich",
            "es": "Permiso necesario",
            "ru": "Требуется разрешение",
            "pt": "Permissão Necessária"
        ],
        "notificationPermissionRequiredBody": [
            "en": "Clipo needs Accessibility permission to save text.",
            "zh-Hans": "Clipo 需要辅助功能权限才能保存文本。",
            "zh-Hant": "Clipo 需要輔助使用權限才能儲存文字。",
            "ja": "Clipo はテキストを保存するためにアクセシビリティ権限が必要です。",
            "ko": "Clipo는 텍스트를 저장하려면 손쉬운 사용 권한이 필요합니다.",
            "fr": "Clipo a besoin de la permission d'accessibilité pour enregistrer du texte.",
            "de": "Clipo benötigt die Bedienungshilfen-Berechtigung, um Text zu speichern.",
            "es": "Clipo necesita permiso de accesibilidad para guardar texto.",
            "ru": "Clipo требуется разрешение спец. возможностей для сохранения текста.",
            "pt": "O Clipo precisa de permissão de Acessibilidade para salvar texto."
        ],
        "notificationSensitiveAppIgnoredTitle": [
            "en": "Sensitive App Ignored",
            "zh-Hans": "已忽略敏感应用",
            "zh-Hant": "已忽略敏感應用程式",
            "ja": "機密アプリを無視しました",
            "ko": "민감한 앱 무시됨",
            "fr": "App sensible ignorée",
            "de": "Sensitive App ignoriert",
            "es": "App sensible ignorada",
            "ru": "Конфиденциальное приложение проигнорировано",
            "pt": "App Sensível Ignorado"
        ],
        "notificationSensitiveAppIgnoredBody": [
            "en": "Clipo does not auto-save from password managers.",
            "zh-Hans": "Clipo 不会自动保存来自密码管理器的内容。",
            "zh-Hant": "Clipo 不會自動儲存來自密碼管理器的內容。",
            "ja": "Clipo はパスワードマネージャーからの自動保存を行いません。",
            "ko": "Clipo는 비밀번호 관리자에서 자동 저장하지 않습니다.",
            "fr": "Clipo n'enregistre pas automatiquement depuis les gestionnaires de mots de passe.",
            "de": "Clipo speichert nicht automatisch aus Passwort-Managern.",
            "es": "Clipo no guarda automáticamente desde administradores de contraseñas.",
            "ru": "Clipo не автосохраняет из менеджеров паролей.",
            "pt": "O Clipo não salva automaticamente de gerenciadores de senhas."
        ],
        "notificationSaveFailedTitle": [
            "en": "Save Failed",
            "zh-Hans": "保存失败",
            "zh-Hant": "儲存失敗",
            "ja": "保存に失敗",
            "ko": "저장 실패",
            "fr": "Échec de l'enregistrement",
            "de": "Speichern fehlgeschlagen",
            "es": "Error al guardar",
            "ru": "Не удалось сохранить",
            "pt": "Falha ao Salvar"
        ],
        "notificationSaveFailedBody": [
            "en": "No text selected or clipboard is empty.",
            "zh-Hans": "未选择文本或剪贴板为空。",
            "zh-Hant": "未選擇文字或剪貼簿為空。",
            "ja": "テキストが選択されていないか、クリップボードが空です。",
            "ko": "선택한 텍스트가 없거나 클립보드가 비어 있습니다.",
            "fr": "Aucun texte sélectionné ou le presse-papiers est vide.",
            "de": "Kein Text markiert oder Zwischenablage ist leer.",
            "es": "No hay texto seleccionado o el portapapeles está vacío.",
            "ru": "Текст не выделен или буфер обмена пуст.",
            "pt": "Nenhum texto selecionado ou a área de transferência está vazia."
        ],
        "notificationHistoryClearedTitle": [
            "en": "History Cleared",
            "zh-Hans": "历史已清除",
            "zh-Hant": "歷史已清除",
            "ja": "履歴をクリアしました",
            "ko": "기록 지워짐",
            "fr": "Historique effacé",
            "de": "Verlauf gelöscht",
            "es": "Historial borrado",
            "ru": "История очищена",
            "pt": "Histórico Limpo"
        ],
        "notificationHistoryClearedBody": [
            "en": "All unpinned history items removed.",
            "zh-Hans": "所有未置顶的历史条目已删除。",
            "zh-Hant": "所有未置頂的歷史項目已刪除。",
            "ja": "固定されていない履歴項目がすべて削除されました。",
            "ko": "고정되지 않은 모든 기록 항목이 제거되었습니다.",
            "fr": "Tous les éléments d'historique non épinglés ont été supprimés.",
            "de": "Alle nicht angehefteten Verlaufselemente wurden entfernt.",
            "es": "Se eliminaron todos los elementos del historial no fijados.",
            "ru": "Все незакреплённые элементы истории удалены.",
            "pt": "Todos os itens do histórico não fixados foram removidos."
        ],
        "notificationSlotsResetTitle": [
            "en": "Slots Reset",
            "zh-Hans": "槽位已重置",
            "zh-Hant": "槽位已重置",
            "ja": "スロットをリセットしました",
            "ko": "슬롯 재설정됨",
            "fr": "Emplacements réinitialisés",
            "de": "Slots zurückgesetzt",
            "es": "Ranuras restablecidas",
            "ru": "Слоты сброшены",
            "pt": "Slots Redefinidos"
        ],
        "notificationSlotsResetBody": [
            "en": "All slots cleared.",
            "zh-Hans": "所有槽位已清空。",
            "zh-Hant": "所有槽位已清空。",
            "ja": "すべてのスロットがクリアされました。",
            "ko": "모든 슬롯이 비워졌습니다.",
            "fr": "Tous les emplacements ont été effacés.",
            "de": "Alle Slots wurden gelöscht.",
            "es": "Todas las ranuras han sido borradas.",
            "ru": "Все слоты очищены.",
            "pt": "Todos os slots foram limpos."
        ],
        "notificationPastePermissionTitle": [
            "en": "Permission Required",
            "zh-Hans": "需要权限",
            "zh-Hant": "需要權限",
            "ja": "権限が必要",
            "ko": "권한 필요",
            "fr": "Permission requise",
            "de": "Berechtigung erforderlich",
            "es": "Permiso necesario",
            "ru": "Требуется разрешение",
            "pt": "Permissão Necessária"
        ],
        "notificationPastePermissionBody": [
            "en": "Clipo needs Accessibility permission to paste text.",
            "zh-Hans": "Clipo 需要辅助功能权限才能粘贴文本。",
            "zh-Hant": "Clipo 需要輔助使用權限才能貼上文字。",
            "ja": "Clipo はテキストを貼り付けるためにアクセシビリティ権限が必要です。",
            "ko": "Clipo는 텍스트를 붙여넣으려면 손쉬운 사용 권한이 필요합니다.",
            "fr": "Clipo a besoin de la permission d'accessibilité pour coller du texte.",
            "de": "Clipo benötigt die Bedienungshilfen-Berechtigung, um Text einzufügen.",
            "es": "Clipo necesita permiso de accesibilidad para pegar texto.",
            "ru": "Clipo требуется разрешение спец. возможностей для вставки текста.",
            "pt": "O Clipo precisa de permissão de Acessibilidade para colar texto."
        ],
        "typeText": [
            "en": "Text",
            "zh-Hans": "文本",
            "zh-Hant": "文字",
            "ja": "テキスト",
            "ko": "텍스트",
            "fr": "Texte",
            "de": "Text",
            "es": "Texto",
            "ru": "Текст",
            "pt": "Texto"
        ],
        "typeURL": [
            "en": "URL",
            "zh-Hans": "链接",
            "zh-Hant": "連結",
            "ja": "URL",
            "ko": "URL",
            "fr": "URL",
            "de": "URL",
            "es": "URL",
            "ru": "URL",
            "pt": "URL"
        ],
        "typeCode": [
            "en": "Code",
            "zh-Hans": "代码",
            "zh-Hant": "程式碼",
            "ja": "コード",
            "ko": "코드",
            "fr": "Code",
            "de": "Code",
            "es": "Código",
            "ru": "Код",
            "pt": "Código"
        ],
        "typeImage": [
            "en": "Image",
            "zh-Hans": "图片",
            "zh-Hant": "圖片",
            "ja": "画像",
            "ko": "이미지",
            "fr": "Image",
            "de": "Bild",
            "es": "Imagen",
            "ru": "Изображение",
            "pt": "Imagem"
        ],
        "typeFile": [
            "en": "File",
            "zh-Hans": "文件",
            "zh-Hant": "檔案",
            "ja": "ファイル",
            "ko": "파일",
            "fr": "Fichier",
            "de": "Datei",
            "es": "Archivo",
            "ru": "Файл",
            "pt": "Arquivo"
        ],
        "typeRich": [
            "en": "Rich",
            "zh-Hans": "富文本",
            "zh-Hant": "豐富文字",
            "ja": "リッチ",
            "ko": "서식 있음",
            "fr": "Enrichi",
            "de": "Rich",
            "es": "Enriquecido",
            "ru": "Rich",
            "pt": "Rich"
        ],
        "typeData": [
            "en": "Data",
            "zh-Hans": "数据",
            "zh-Hant": "資料",
            "ja": "データ",
            "ko": "데이터",
            "fr": "Données",
            "de": "Daten",
            "es": "Datos",
            "ru": "Данные",
            "pt": "Dados"
        ],
        "pinnedLabel": [
            "en": "Pinned",
            "zh-Hans": "置顶",
            "zh-Hant": "置頂",
            "ja": "固定済み",
            "ko": "고정됨",
            "fr": "Épinglé",
            "de": "Angeheftet",
            "es": "Fijado",
            "ru": "Закреплено",
            "pt": "Fixado"
        ],
        "justNow": [
            "en": "Just now",
            "zh-Hans": "刚刚",
            "zh-Hant": "剛剛",
            "ja": "たった今",
            "ko": "방금",
            "fr": "À l'instant",
            "de": "Gerade eben",
            "es": "Justo ahora",
            "ru": "Только что",
            "pt": "Agora mesmo"
        ],
        "minutesAgoTemplate": [
            "en": "%dm ago",
            "zh-Hans": "%d 分钟前",
            "zh-Hant": "%d 分鐘前",
            "ja": "%d 分前",
            "ko": "%d분 전",
            "fr": "Il y a %d min",
            "de": "Vor %d Min",
            "es": "Hace %d min",
            "ru": "%d мин назад",
            "pt": "Há %d min"
        ],
        "hoursAgoTemplate": [
            "en": "%dh ago",
            "zh-Hans": "%d 小时前",
            "zh-Hant": "%d 小時前",
            "ja": "%d 時間前",
            "ko": "%d시간 전",
            "fr": "Il y a %d h",
            "de": "Vor %d Std",
            "es": "Hace %d h",
            "ru": "%d ч назад",
            "pt": "Há %d h"
        ],
        "loadingText": [
            "en": "Loading...",
            "zh-Hans": "加载中...",
            "zh-Hant": "載入中...",
            "ja": "読み込み中...",
            "ko": "로딩 중...",
            "fr": "Chargement...",
            "de": "Laden...",
            "es": "Cargando...",
            "ru": "Загрузка...",
            "pt": "Carregando..."
        ],
        "emptySlot": [
            "en": "Empty",
            "zh-Hans": "空",
            "zh-Hant": "空",
            "ja": "空",
            "ko": "비어 있음",
            "fr": "Vide",
            "de": "Leer",
            "es": "Vacía",
            "ru": "Пусто",
            "pt": "Vazio"
        ],
        "runningTitle": [
            "en": "Clipo is Running",
            "zh-Hans": "Clipo 正在运行",
            "zh-Hant": "Clipo 正在執行",
            "ja": "Clipo が実行中です",
            "ko": "Clipo 실행 중",
            "fr": "Clipo est en cours d'exécution",
            "de": "Clipo wird ausgeführt",
            "es": "Clipo se está ejecutando",
            "ru": "Clipo запущен",
            "pt": "Clipo está em execução"
        ],
        "runningBody": [
            "en": "Look for the clipboard icon in your menu bar. You can enable Accessibility later via the menu.",
            "zh-Hans": "在菜单栏中寻找剪贴板图标。您可以稍后通过菜单启用辅助功能。",
            "zh-Hant": "在選單列中尋找剪貼簿圖示。您可以稍後透過選單啟用輔助使用。",
            "ja": "メニューバーにクリップボードアイコンがあります。後からメニューでアクセシビリティを有効にできます。",
            "ko": "메뉴 표시줄에서 클립보드 아이콘을 찾아보세요. 나중에 메뉴를 통해 손쉬운 사용을 활성화할 수 있습니다.",
            "fr": "Recherchez l'icône du presse-papiers dans votre barre de menus. Vous pouvez activer l'accessibilité plus tard via le menu.",
            "de": "Suchen Sie das Clipboard-Symbol in Ihrer Menüleiste. Sie können Bedienungshilfen später über das Menü aktivieren.",
            "es": "Busque el icono del portapapeles en su barra de menús. Puede habilitar la accesibilidad más tarde mediante el menú.",
            "ru": "Найдите значок буфера обмена в строке меню. Вы можете включить спец. возможности позже через меню.",
            "pt": "Procure o ícone da área de transferência na sua barra de menus. Você pode habilitar a Acessibilidade posteriormente pelo menu."
        ],
        "dockEnabledTitle": [
            "en": "Dock Icon Enabled",
            "zh-Hans": "程序坞图标已启用",
            "zh-Hant": "Dock 圖示已啟用",
            "ja": "Dock アイコンが有効になりました",
            "ko": "Dock 아이콘 활성화됨",
            "fr": "Icône du Dock activée",
            "de": "Dock-Symbol aktiviert",
            "es": "Icono del Dock habilitado",
            "ru": "Значок Dock включён",
            "pt": "Ícone do Dock Ativado"
        ],
        "dockEnabledBody": [
            "en": "The Clipo icon now appears in the Dock.",
            "zh-Hans": "Clipo 图标现在显示在程序坞中。",
            "zh-Hant": "Clipo 圖示現在顯示在 Dock 中。",
            "ja": "Clipo アイコンが Dock に表示されるようになりました。",
            "ko": "Clipo 아이콘이 이제 Dock에 표시됩니다.",
            "fr": "L'icône Clipo apparaît maintenant dans le Dock.",
            "de": "Das Clipo-Symbol erscheint jetzt im Dock.",
            "es": "El icono de Clipo ahora aparece en el Dock.",
            "ru": "Значок Clipo теперь отображается в Dock.",
            "pt": "O ícone do Clipo agora aparece no Dock."
        ],
        "dockHiddenTitle": [
            "en": "Dock Icon Hidden",
            "zh-Hans": "程序坞图标已隐藏",
            "zh-Hant": "Dock 圖示已隱藏",
            "ja": "Dock アイコンが非表示になりました",
            "ko": "Dock 아이콘 숨김",
            "fr": "Icône du Dock masquée",
            "de": "Dock-Symbol ausgeblendet",
            "es": "Icono del Dock oculto",
            "ru": "Значок Dock скрыт",
            "pt": "Ícone do Dock Oculto"
        ],
        "dockHiddenBody": [
            "en": "The Dock icon will disappear after you restart Clipo.",
            "zh-Hans": "重启 Clipo 后程序坞图标将消失。",
            "zh-Hant": "重新啟動 Clipo 後 Dock 圖示將消失。",
            "ja": "Clipo を再起動すると Dock アイコンが非表示になります。",
            "ko": "Clipo를 다시 시작하면 Dock 아이콘이 사라집니다.",
            "fr": "L'icône du Dock disparaîtra après le redémarrage de Clipo.",
            "de": "Das Dock-Symbol verschwindet, nachdem Sie Clipo neu gestartet haben.",
            "es": "El icono del Dock desaparecerá después de reiniciar Clipo.",
            "ru": "Значок Dock исчезнет после перезапуска Clipo.",
            "pt": "O ícone do Dock desaparecerá após reiniciar o Clipo."
        ],
        "settingSavedTitle": [
            "en": "Setting Saved",
            "zh-Hans": "设置已保存",
            "zh-Hant": "設定已儲存",
            "ja": "設定を保存しました",
            "ko": "설정 저장됨",
            "fr": "Paramètre enregistré",
            "de": "Einstellung gespeichert",
            "es": "Ajuste guardado",
            "ru": "Настройка сохранена",
            "pt": "Configuração Salva"
        ],
        "settingSavedBody": [
            "en": "The change will take effect after you restart Clipo.",
            "zh-Hans": "更改将在重启 Clipo 后生效。",
            "zh-Hant": "變更將在重新啟動 Clipo 後生效。",
            "ja": "変更は Clipo の再起動後に有効になります。",
            "ko": "변경 사항은 Clipo를 다시 시작한 후 적용됩니다.",
            "fr": "Le changement prendra effet après le redémarrage de Clipo.",
            "de": "Die Änderung tritt nach dem Neustart von Clipo in Kraft.",
            "es": "El cambio surtirá efecto después de reiniciar Clipo.",
            "ru": "Изменение вступит в силу после перезапуска Clipo.",
            "pt": "A alteração terá efeito após reiniciar o Clipo."
        ],
        "importSuccessTitle": [
            "en": "Import Successful",
            "zh-Hans": "导入成功",
            "zh-Hant": "匯入成功",
            "ja": "インポート成功",
            "ko": "가져오기 성공",
            "fr": "Importation réussie",
            "de": "Import erfolgreich",
            "es": "Importación exitosa",
            "ru": "Импорт выполнен",
            "pt": "Importação Bem-sucedida"
        ],
        "importSuccessBody": [
            "en": "Data restored from %@",
            "zh-Hans": "数据已从 %@ 恢复",
            "zh-Hant": "資料已從 %@ 恢復",
            "ja": "データを %@ から復元しました",
            "ko": "%@에서 데이터 복원됨",
            "fr": "Données restaurées depuis %@",
            "de": "Daten aus %@ wiederhergestellt",
            "es": "Datos restaurados desde %@",
            "ru": "Данные восстановлены из %@",
            "pt": "Dados restaurados de %@"
        ],
        "importSuccessRestartBody": [
            "en": "Data restored. Dock icon change will take effect after restart.",
            "zh-Hans": "数据已恢复。Dock 图标更改将在重启后生效。",
            "zh-Hant": "資料已恢復。Dock 圖示變更將在重新啟動後生效。",
            "ja": "データが復元されました。Dock アイコンの変更は再起動後に有効になります。",
            "ko": "데이터가 복원되었습니다. Dock 아이콘 변경은 다시 시작 후 적용됩니다.",
            "fr": "Données restaurées. Le changement d'icône du Dock prendra effet après le redémarrage.",
            "de": "Daten wiederhergestellt. Dock-Symbol-Änderung tritt nach dem Neustart in Kraft.",
            "es": "Datos restaurados. El cambio de icono del Dock surtirá efecto después de reiniciar.",
            "ru": "Данные восстановлены. Изменение значка Dock вступит в силу после перезапуска.",
            "pt": "Dados restaurados. A alteração do ícone do Dock terá efeito após reiniciar."
        ],
        "exportSuccessTitle": [
            "en": "Export Successful",
            "zh-Hans": "导出成功",
            "zh-Hant": "匯出成功",
            "ja": "エクスポート成功",
            "ko": "내보내기 성공",
            "fr": "Exportation réussie",
            "de": "Export erfolgreich",
            "es": "Exportación exitosa",
            "ru": "Экспорт выполнен",
            "pt": "Exportação Bem-sucedida"
        ],
        "exportSuccessBody": [
            "en": "Data saved to %@",
            "zh-Hans": "数据已保存到 %@",
            "zh-Hant": "資料已儲存到 %@",
            "ja": "データを %@ に保存しました",
            "ko": "%@에 데이터 저장됨",
            "fr": "Données enregistrées dans %@",
            "de": "Daten in %@ gespeichert",
            "es": "Datos guardados en %@",
            "ru": "Данные сохранены в %@",
            "pt": "Dados salvos em %@"
        ],
        "autoDeleteNever": [
            "en": "Never",
            "zh-Hans": "从不",
            "zh-Hant": "從不",
            "ja": "しない",
            "ko": "안 함",
            "fr": "Jamais",
            "de": "Nie",
            "es": "Nunca",
            "ru": "Никогда",
            "pt": "Nunca"
        ],
        "autoDeleteOneDay": [
            "en": "1 Day",
            "zh-Hans": "1 天",
            "zh-Hant": "1 天",
            "ja": "1 日",
            "ko": "1일",
            "fr": "1 jour",
            "de": "1 Tag",
            "es": "1 día",
            "ru": "1 день",
            "pt": "1 dia"
        ],
        "autoDeleteSevenDays": [
            "en": "7 Days",
            "zh-Hans": "7 天",
            "zh-Hant": "7 天",
            "ja": "7 日",
            "ko": "7일",
            "fr": "7 jours",
            "de": "7 Tage",
            "es": "7 días",
            "ru": "7 дней",
            "pt": "7 dias"
        ],
        "autoDeleteThirtyDays": [
            "en": "30 Days",
            "zh-Hans": "30 天",
            "zh-Hant": "30 天",
            "ja": "30 日",
            "ko": "30일",
            "fr": "30 jours",
            "de": "30 Tage",
            "es": "30 días",
            "ru": "30 дней",
            "pt": "30 dias"
        ],
        "accessibilityWaitingMessage": [
            "en": "Waiting for macOS to confirm Accessibility access. If it is already enabled but still not working, quit and reopen Clipo, or remove the old Clipo entry and add the current build again.",
            "zh-Hans": "正在等待 macOS 确认辅助功能权限。如果已启用但仍无法工作，请退出并重新打开 Clipo，或删除旧的 Clipo 条目并重新添加当前构建。",
            "zh-Hant": "正在等待 macOS 確認輔助使用權限。如果已啟用但仍無法運作，請結束並重新打開 Clipo，或刪除舊的 Clipo 項目並重新加入目前構建。",
            "ja": "macOS がアクセシビリティ権限を確認するのを待っています。既に有効になっているのに動作しない場合は、Clipo を終了して再度開くか、古い Clipo エントリを削除して現在のビルドを再追加してください。",
            "ko": "macOS가 손쉬운 사용 권한을 확인할 때까지 대기 중입니다. 이미 활성화되어 있지만 여전히 작동하지 않는 경우 Clipo를 종료하고 다시 열거나, 이전 Clipo 항목을 제거하고 현재 빌드를 다시 추가하세요.",
            "fr": "En attente de confirmation de l'accès à l'accessibilité par macOS. Si c'est déjà activé mais ne fonctionne toujours pas, quittez et rouvrez Clipo, ou supprimez l'ancienne entrée Clipo et rajoutez le build actuel.",
            "de": "Warte auf Bestätigung der Bedienungshilfen-Berechtigung durch macOS. Falls bereits aktiviert, aber nicht funktioniert, beenden und öffnen Sie Clipo erneut, oder entfernen Sie den alten Clipo-Eintrag und fügen Sie den aktuellen Build erneut hinzu.",
            "es": "Esperando que macOS confirme el acceso de accesibilidad. Si ya está habilitado pero aún no funciona, salga y vuelva a abrir Clipo, o elimine la entrada antigua de Clipo y agregue la compilación actual nuevamente.",
            "ru": "Ожидание подтверждения доступа спец. возможностей от macOS. Если уже включено, но не работает, завершите и перезапустите Clipo, или удалите старую запись Clipo и добавьте текущую сборку заново.",
            "pt": "Aguardando o macOS confirmar o acesso à Acessibilidade. Se já estiver ativado, mas ainda não funcionar, encerre e reabra o Clipo, ou remova a entrada antiga do Clipo e readicione o build atual."
        ],
        "accessibilityRequiredTemplate": [
            "en": "Clipo needs Accessibility permission to %@.",
            "zh-Hans": "Clipo 需要辅助功能权限才能%@。",
            "zh-Hant": "Clipo 需要輔助使用權限才能%@。",
            "ja": "Clipo は%@するためにアクセシビリティ権限が必要です。",
            "ko": "Clipo는 %@하려면 손쉬운 사용 권한이 필요합니다.",
            "fr": "Clipo a besoin de la permission d'accessibilité pour %@.",
            "de": "Clipo benötigt die Bedienungshilfen-Berechtigung, um %@.",
            "es": "Clipo necesita permiso de accesibilidad para %@.",
            "ru": "Clipo требуется разрешение спец. возможностей для %@.",
            "pt": "O Clipo precisa de permissão de Acessibilidade para %@."
        ],
        "checkingPermission": [
            "en": "Checking Permission",
            "zh-Hans": "正在检查权限",
            "zh-Hant": "正在檢查權限",
            "ja": "権限を確認中",
            "ko": "권한 확인 중",
            "fr": "Vérification des permissions",
            "de": "Berechtigung wird überprüft",
            "es": "Comprobando permiso",
            "ru": "Проверка разрешения",
            "pt": "Verificando Permissão"
        ],
        "checkAgainButton": [
            "en": "Check Again",
            "zh-Hans": "再次检查",
            "zh-Hant": "再次檢查",
            "ja": "再確認",
            "ko": "다시 확인",
            "fr": "Revérifier",
            "de": "Erneut prüfen",
            "es": "Verificar de nuevo",
            "ru": "Проверить снова",
            "pt": "Verificar Novamente"
        ],
        "allFilter": [
            "en": "All",
            "zh-Hans": "全部",
            "zh-Hant": "全部",
            "ja": "すべて",
            "ko": "전체",
            "fr": "Tout",
            "de": "Alle",
            "es": "Todo",
            "ru": "Все",
            "pt": "Todos"
        ],
        "exportFailedTitle": [
            "en": "Export Failed",
            "zh-Hans": "导出失败",
            "zh-Hant": "匯出失敗",
            "ja": "エクスポート失敗",
            "ko": "내보내기 실패",
            "fr": "Échec de l'exportation",
            "de": "Export fehlgeschlagen",
            "es": "Error al exportar",
            "ru": "Не удалось экспортировать",
            "pt": "Falha na Exportação"
        ],
        "exportFailedMessage": [
            "en": "Clipo could not export your data. Please try again.",
            "zh-Hans": "Clipo 无法导出您的数据。请重试。",
            "zh-Hant": "Clipo 無法匯出您的資料。請重試。",
            "ja": "Clipo はデータをエクスポートできませんでした。もう一度お試しください。",
            "ko": "Clipo가 데이터를 내보낼 수 없습니다. 다시 시도해 주세요.",
            "fr": "Clipo n'a pas pu exporter vos données. Veuillez réessayer.",
            "de": "Clipo konnte Ihre Daten nicht exportieren. Bitte versuchen Sie es erneut.",
            "es": "Clipo no pudo exportar sus datos. Inténtelo de nuevo.",
            "ru": "Clipo не удалось экспортировать данные. Пожалуйста, попробуйте снова.",
            "pt": "O Clipo não conseguiu exportar seus dados. Tente novamente."
        ],
        "importFailedTitle": [
            "en": "Import Failed",
            "zh-Hans": "导入失败",
            "zh-Hant": "匯入失敗",
            "ja": "インポート失敗",
            "ko": "가져오기 실패",
            "fr": "Échec de l'importation",
            "de": "Import fehlgeschlagen",
            "es": "Error al importar",
            "ru": "Не удалось импортировать",
            "pt": "Falha na Importação"
        ],
        "importFailedMessage": [
            "en": "The selected file is invalid or corrupted. Your existing data was not changed.",
            "zh-Hans": "所选文件无效或已损坏。您现有的数据未被更改。",
            "zh-Hant": "所選檔案無效或已損壞。您現有的資料未被更改。",
            "ja": "選択したファイルが無効または破損しています。既存のデータは変更されていません。",
            "ko": "선택한 파일이 유효하지 않거나 손상되었습니다. 기존 데이터는 변경되지 않았습니다.",
            "fr": "Le fichier sélectionné est invalide ou corrompu. Vos données existantes n'ont pas été modifiées.",
            "de": "Die ausgewählte Datei ist ungültig oder beschädigt. Ihre vorhandenen Daten wurden nicht geändert.",
            "es": "El archivo seleccionado no es válido o está dañado. Sus datos existentes no se modificaron.",
            "ru": "Выбранный файл недействителен или повреждён. Существующие данные не были изменены.",
            "pt": "O arquivo selecionado é inválido ou corrompido. Seus dados existentes não foram alterados."
        ],
        "hotkeyRegistrationFailedTitle": [
            "en": "Hotkey Registration Failed",
            "zh-Hans": "热键注册失败",
            "zh-Hant": "熱鍵註冊失敗",
            "ja": "ホットキーの登録に失敗",
            "ko": "단축키 등록 실패",
            "fr": "Échec de l'enregistrement du raccourci",
            "de": "Tastenkürzel-Registrierung fehlgeschlagen",
            "es": "Error al registrar atajo",
            "ru": "Не удалось зарегистрировать горячую клавишу",
            "pt": "Falha no Registro de Atalho"
        ],
        "hotkeyRegistrationFailedTemplate": [
            "en": "Shortcut id %d could not be registered. It may conflict with another app.",
            "zh-Hans": "快捷键 ID %d 无法注册。可能与其他应用冲突。",
            "zh-Hant": "快捷鍵 ID %d 無法註冊。可能與其他應用程式衝突。",
            "ja": "ショートカット ID %d を登録できませんでした。他のアプリと競合している可能性があります。",
            "ko": "단축키 ID %d를 등록할 수 없습니다. 다른 앱과 충돌할 수 있습니다.",
            "fr": "Le raccourci id %d n'a pas pu être enregistré. Il peut entrer en conflit avec une autre app.",
            "de": "Tastenkürzel-ID %d konnte nicht registriert werden. Möglicherweise konfligiert es mit einer anderen App.",
            "es": "No se pudo registrar el atajo id %d. Puede entrar en conflicto con otra app.",
            "ru": "Не удалось зарегистрировать горячую клавишу id %d. Возможен конфликт с другим приложением.",
            "pt": "Não foi possível registrar o atalho id %d. Pode estar em conflito com outro app."
        ],
        "dataResetTitle": [
            "en": "Data Reset",
            "zh-Hans": "数据已重置",
            "zh-Hant": "資料已重置",
            "ja": "データをリセットしました",
            "ko": "데이터 재설정됨",
            "fr": "Données réinitialisées",
            "de": "Daten zurückgesetzt",
            "es": "Datos restablecidos",
            "ru": "Данные сброшены",
            "pt": "Dados Redefinidos"
        ],
        "dataResetBody": [
            "en": "Your saved data was corrupted and has been reset. A backup was created.",
            "zh-Hans": "您保存的数据已损坏并已被重置。已创建备份。",
            "zh-Hant": "您儲存的資料已損壞並已被重置。已建立備份。",
            "ja": "保存されたデータが破損していたためリセットされました。バックアップが作成されました。",
            "ko": "저장된 데이터가 손상되어 재설정되었습니다. 백업이 생성되었습니다.",
            "fr": "Vos données enregistrées étaient corrompues et ont été réinitialisées. Une sauvegarde a été créée.",
            "de": "Ihre gespeicherten Daten waren beschädigt und wurden zurückgesetzt. Ein Backup wurde erstellt.",
            "es": "Sus datos guardados estaban dañados y se han restablecido. Se creó una copia de seguridad.",
            "ru": "Сохранённые данные были повреждены и сброшены. Резервная копия создана.",
            "pt": "Seus dados salvos estavam corrompidos e foram redefinidos. Um backup foi criado."
        ],
        "saveFailedTitle": [
            "en": "Save Failed",
            "zh-Hans": "保存失败",
            "zh-Hant": "儲存失敗",
            "ja": "保存に失敗",
            "ko": "저장 실패",
            "fr": "Échec de l'enregistrement",
            "de": "Speichern fehlgeschlagen",
            "es": "Error al guardar",
            "ru": "Не удалось сохранить",
            "pt": "Falha ao Salvar"
        ],
        "saveFailedBody": [
            "en": "Clipo could not write to disk. Your changes may not persist.",
            "zh-Hans": "Clipo 无法写入磁盘。您的更改可能不会保留。",
            "zh-Hant": "Clipo 無法寫入磁碟。您的變更可能不會保留。",
            "ja": "Clipo はディスクに書き込めませんでした。変更が保持されない可能性があります。",
            "ko": "Clipo가 디스크에 쓸 수 없습니다. 변경 사항이 유지되지 않을 수 있습니다.",
            "fr": "Clipo n'a pas pu écrire sur le disque. Vos modifications peuvent ne pas persister.",
            "de": "Clipo konnte nicht auf die Festplatte schreiben. Ihre Änderungen werden möglicherweise nicht beibehalten.",
            "es": "Clipo no pudo escribir en el disco. Es posible que sus cambios no persistan.",
            "ru": "Clipo не удалось записать на диск. Ваши изменения могут не сохраниться.",
            "pt": "O Clipo não conseguiu gravar no disco. Suas alterações podem não persistir."
        ],
        "launchAtLoginFailedBody": [
            "en": "Please ensure the app is code-signed to use this feature.",
            "zh-Hans": "请确保应用已进行代码签名才能使用此功能。",
            "zh-Hant": "請確保應用程式已進行程式碼簽署才能使用此功能。",
            "ja": "この機能を使用するにはアプリがコード署名されていることを確認してください。",
            "ko": "이 기능을 사용하려면 앱이 코드 서명되어 있는지 확인하세요.",
            "fr": "Veuillez vous assurer que l'app est signée pour utiliser cette fonctionnalité.",
            "de": "Bitte stellen Sie sicher, dass die App code-signiert ist, um diese Funktion zu nutzen.",
            "es": "Asegúrese de que la app esté firmada para usar esta función.",
            "ru": "Убедитесь, что приложение подписано, чтобы использовать эту функцию.",
            "pt": "Certifique-se de que o app esteja assinado para usar este recurso."
        ],
        "accessibilityEnabledDescription": [
            "en": "Clipo can save selections and paste from slots.",
            "zh-Hans": "Clipo 可以保存所选内容并从槽位粘贴。",
            "zh-Hant": "Clipo 可以儲存所選內容並從槽位貼上。",
            "ja": "Clipo は選択を保存し、スロットから貼り付けることができます。",
            "ko": "Clipo는 선택 항목을 저장하고 슬롯에서 붙여넣을 수 있습니다.",
            "fr": "Clipo peut enregistrer les sélections et coller depuis les emplacements.",
            "de": "Clipo kann Auswahlen speichern und aus Slots einfügen.",
            "es": "Clipo puede guardar selecciones y pegar desde ranuras.",
            "ru": "Clipo может сохранять выделенное и вставлять из слотов.",
            "pt": "O Clipo pode salvar seleções e colar dos slots."
        ],
        "checkingAccessibilityPermissionMenu": [
            "en": "Checking Accessibility Permission…",
            "zh-Hans": "正在检查辅助功能权限…",
            "zh-Hant": "正在檢查輔助使用權限…",
            "ja": "アクセシビリティ権限を確認中…",
            "ko": "손쉬운 사용 권한 확인 중…",
            "fr": "Vérification de la permission d'accessibilité…",
            "de": "Bedienungshilfen-Berechtigung wird überprüft…",
            "es": "Comprobando permiso de accesibilidad…",
            "ru": "Проверка разрешения спец. возможностей…",
            "pt": "Verificando Permissão de Acessibilidade…"
        ],
        "customLabel": [
            "en": "Custom",
            "zh-Hans": "自定义",
            "zh-Hant": "自訂",
            "ja": "カスタム",
            "ko": "사용자 지정",
            "fr": "Personnalisé",
            "de": "Benutzerdefiniert",
            "es": "Personalizado",
            "ru": "Пользовательский",
            "pt": "Personalizado"
        ],
        "keyCodeTemplate": [
            "en": "Key %d",
            "zh-Hans": "键 %d",
            "zh-Hant": "鍵 %d",
            "ja": "キー %d",
            "ko": "키 %d",
            "fr": "Touche %d",
            "de": "Taste %d",
            "es": "Tecla %d",
            "ru": "Клавиша %d",
            "pt": "Tecla %d"
        ],
        "sectionSoundEffects": [
            "en": "Sound Effects",
            "zh-Hans": "音效",
            "zh-Hant": "音效",
            "ja": "効果音",
            "ko": "효과음",
            "fr": "Effets sonores",
            "de": "Soundeffekte",
            "es": "Efectos de sonido",
            "ru": "Звуковые эффекты",
            "pt": "Efeitos Sonoros"
        ],
        "sfxMasterToggle": [
            "en": "Enable Sound Effects",
            "zh-Hans": "启用音效",
            "zh-Hant": "啟用音效",
            "ja": "効果音を有効にする",
            "ko": "효과음 활성화",
            "fr": "Activer les effets sonores",
            "de": "Soundeffekte aktivieren",
            "es": "Activar efectos de sonido",
            "ru": "Включить звуковые эффекты",
            "pt": "Ativar Efeitos Sonoros"
        ],
        "sfxMasterToggleSubtitle": [
            "en": "Play audio feedback for actions",
            "zh-Hans": "为操作播放音频反馈",
            "zh-Hant": "為操作播放音訊回饋",
            "ja": "アクション時に音を再生",
            "ko": "작업에 대한 오디오 피드백 재생",
            "fr": "Jouer un retour audio pour les actions",
            "de": "Audio-Feedback für Aktionen abspielen",
            "es": "Reproducir retroalimentación de audio para acciones",
            "ru": "Воспроизводить звуковую обратную связь для действий",
            "pt": "Reproduzir feedback de áudio para ações"
        ],
        "sfxVolumeTitle": [
            "en": "Volume",
            "zh-Hans": "音量",
            "zh-Hant": "音量",
            "ja": "音量",
            "ko": "볼륨",
            "fr": "Volume",
            "de": "Lautstärke",
            "es": "Volumen",
            "ru": "Громкость",
            "pt": "Volume"
        ],
        "sfxCopyToggle": [
            "en": "Copy",
            "zh-Hans": "复制",
            "zh-Hant": "複製",
            "ja": "コピー",
            "ko": "복사",
            "fr": "Copier",
            "de": "Kopieren",
            "es": "Copiar",
            "ru": "Копировать",
            "pt": "Copiar"
        ],
        "sfxPasteToggle": [
            "en": "Paste",
            "zh-Hans": "粘贴",
            "zh-Hant": "貼上",
            "ja": "貼り付け",
            "ko": "붙여넣기",
            "fr": "Coller",
            "de": "Einfügen",
            "es": "Pegar",
            "ru": "Вставить",
            "pt": "Colar"
        ],
        "sfxSaveToggle": [
            "en": "Save to Slot",
            "zh-Hans": "保存到槽位",
            "zh-Hant": "儲存到槽位",
            "ja": "スロットに保存",
            "ko": "슬롯에 저장",
            "fr": "Enregistrer dans l'emplacement",
            "de": "In Slot speichern",
            "es": "Guardar en ranura",
            "ru": "Сохранить в слот",
            "pt": "Salvar no Slot"
        ],
        "sfxOpenToggle": [
            "en": "Open Panel",
            "zh-Hans": "打开面板",
            "zh-Hant": "打開面板",
            "ja": "パネルを開く",
            "ko": "패널 열기",
            "fr": "Ouvrir le panneau",
            "de": "Panel öffnen",
            "es": "Abrir panel",
            "ru": "Открыть панель",
            "pt": "Abrir Painel"
        ],
        "sfxCloseToggle": [
            "en": "Close Panel",
            "zh-Hans": "关闭面板",
            "zh-Hant": "關閉面板",
            "ja": "パネルを閉じる",
            "ko": "패널 닫기",
            "fr": "Fermer le panneau",
            "de": "Panel schließen",
            "es": "Cerrar panel",
            "ru": "Закрыть панель",
            "pt": "Fechar Painel"
        ],
        "sfxErrorToggle": [
            "en": "Error",
            "zh-Hans": "错误",
            "zh-Hant": "錯誤",
            "ja": "エラー",
            "ko": "오류",
            "fr": "Erreur",
            "de": "Fehler",
            "es": "Error",
            "ru": "Ошибка",
            "pt": "Erro"
        ],
        "sfxResetToggle": [
            "en": "Reset",
            "zh-Hans": "重置",
            "zh-Hant": "重置",
            "ja": "リセット",
            "ko": "재설정",
            "fr": "Réinitialiser",
            "de": "Zurücksetzen",
            "es": "Restablecer",
            "ru": "Сброс",
            "pt": "Redefinir"
        ],
        "tabInsights": [
            "en": "Insights",
            "zh-Hans": "统计",
            "zh-Hant": "統計",
            "ja": "統計",
            "ko": "통계",
            "fr": "Statistiques",
            "de": "Einblicke",
            "es": "Estadísticas",
            "ru": "Статистика",
            "pt": "Estatísticas"
        ],
        "statTodayLabel": [
            "en": "Today",
            "zh-Hans": "今日",
            "zh-Hant": "今日",
            "ja": "今日",
            "ko": "오늘",
            "fr": "Aujourd'hui",
            "de": "Heute",
            "es": "Hoy",
            "ru": "Сегодня",
            "pt": "Hoje"
        ],
        "statWeekLabel": [
            "en": "This Week",
            "zh-Hans": "本周",
            "zh-Hant": "本週",
            "ja": "今週",
            "ko": "이번 주",
            "fr": "Cette semaine",
            "de": "Diese Woche",
            "es": "Esta semana",
            "ru": "На этой неделе",
            "pt": "Esta semana"
        ],
        "statTotalLabel": [
            "en": "Total",
            "zh-Hans": "总计",
            "zh-Hant": "總計",
            "ja": "合計",
            "ko": "총계",
            "fr": "Total",
            "de": "Gesamt",
            "es": "Total",
            "ru": "Всего",
            "pt": "Total"
        ],
        "statSourcesLabel": [
            "en": "Sources",
            "zh-Hans": "来源",
            "zh-Hant": "來源",
            "ja": "ソース",
            "ko": "출처",
            "fr": "Sources",
            "de": "Quellen",
            "es": "Fuentes",
            "ru": "Источники",
            "pt": "Fontes"
        ],
        "trendTitle": [
            "en": "7-Day Trend",
            "zh-Hans": "7天趋势",
            "zh-Hant": "7天趨勢",
            "ja": "7日間の推移",
            "ko": "7일 추이",
            "fr": "Tendance sur 7 jours",
            "de": "7-Tage-Trend",
            "es": "Tendencia de 7 días",
            "ru": "Тренд за 7 дней",
            "pt": "Tendência de 7 Dias"
        ],
        "hourlyTitle": [
            "en": "Hourly Activity",
            "zh-Hans": "每小时活动",
            "zh-Hant": "每小時活動",
            "ja": "時間別アクティビティ",
            "ko": "시간대별 활동",
            "fr": "Activité horaire",
            "de": "Stündliche Aktivität",
            "es": "Actividad por hora",
            "ru": "Активность по часам",
            "pt": "Atividade por Hora"
        ],
        "peakHourTemplate": [
            "en": "Peak: %d:00",
            "zh-Hans": "高峰: %d:00",
            "zh-Hant": "高峰: %d:00",
            "ja": "ピーク: %d:00",
            "ko": "피크: %d:00",
            "fr": "Pic: %d h",
            "de": "Spitze: %d:00",
            "es": "Pico: %d:00",
            "ru": "Пик: %d:00",
            "pt": "Pico: %d:00"
        ],
        "typeDistTitle": [
            "en": "Content Types",
            "zh-Hans": "内容类型",
            "zh-Hant": "內容類型",
            "ja": "コンテンツタイプ",
            "ko": "콘텐츠 유형",
            "fr": "Types de contenu",
            "de": "Inhaltstypen",
            "es": "Tipos de contenido",
            "ru": "Типы контента",
            "pt": "Tipos de Conteúdo"
        ],
        "topSourcesTitle": [
            "en": "Top Sources",
            "zh-Hans": "主要来源",
            "zh-Hant": "主要來源",
            "ja": "主要ソース",
            "ko": "주요 출처",
            "fr": "Principales sources",
            "de": "Hauptquellen",
            "es": "Principales fuentes",
            "ru": "Топ источников",
            "pt": "Principais Fontes"
        ],
        "slotUtilTitle": [
            "en": "Slot Usage",
            "zh-Hans": "槽位使用",
            "zh-Hant": "槽位使用",
            "ja": "スロット使用状況",
            "ko": "슬롯 사용량",
            "fr": "Utilisation des emplacements",
            "de": "Slot-Nutzung",
            "es": "Uso de ranuras",
            "ru": "Использование слотов",
            "pt": "Uso de Slots"
        ],
        "slotUtilTemplate": [
            "en": "%d of %d slots filled",
            "zh-Hans": "已使用 %d/%d 个槽位",
            "zh-Hant": "已使用 %d/%d 個槽位",
            "ja": "%d/%d スロット使用中",
            "ko": "%d/%d 슬롯 사용 중",
            "fr": "%d sur %d emplacements remplis",
            "de": "%d von %d Slots belegt",
            "es": "%d de %d ranuras ocupadas",
            "ru": "%d из %d слотов заполнено",
            "pt": "%d de %d slots preenchidos"
        ],
        "noDataLabel": [
            "en": "No data yet",
            "zh-Hans": "暂无数据",
            "zh-Hant": "暫無數據",
            "ja": "まだデータがありません",
            "ko": "아직 데이터가 없습니다",
            "fr": "Pas encore de données",
            "de": "Noch keine Daten",
            "es": "Aún no hay datos",
            "ru": "Пока нет данных",
            "pt": "Ainda sem dados"
        ],
        "unknownSource": [
            "en": "Unknown",
            "zh-Hans": "未知",
            "zh-Hant": "未知",
            "ja": "不明",
            "ko": "알 수 없음",
            "fr": "Inconnu",
            "de": "Unbekannt",
            "es": "Desconocido",
            "ru": "Неизвестно",
            "pt": "Desconhecido"
        ],
        "todayLabel": [
            "en": "Today",
            "zh-Hans": "今天",
            "zh-Hant": "今天",
            "ja": "今日",
            "ko": "오늘",
            "fr": "Aujourd'hui",
            "de": "Heute",
            "es": "Hoy",
            "ru": "Сегодня",
            "pt": "Hoje"
        ],
        "hourlyStartLabel": [
            "en": "00:00",
            "zh-Hans": "00:00",
            "zh-Hant": "00:00",
            "ja": "00:00",
            "ko": "00:00",
            "fr": "00:00",
            "de": "00:00",
            "es": "00:00",
            "ru": "00:00",
            "pt": "00:00"
        ],
        "hourlyEndLabel": [
            "en": "23:00",
            "zh-Hans": "23:00",
            "zh-Hant": "23:00",
            "ja": "23:00",
            "ko": "23:00",
            "fr": "23:00",
            "de": "23:00",
            "es": "23:00",
            "ru": "23:00",
            "pt": "23:00"
        ],
        "slotUtilEmptyLabel": [
            "en": "—",
            "zh-Hans": "—",
            "zh-Hant": "—",
            "ja": "—",
            "ko": "—",
            "fr": "—",
            "de": "—",
            "es": "—",
            "ru": "—",
            "pt": "—"
        ],
        "showSourceAppTitle": [
            "en": "Show Source App",
            "zh-Hans": "显示来源应用",
            "zh-Hant": "顯示來源應用程式",
            "ja": "ソースアプリを表示",
            "ko": "원본 앱 표시",
            "fr": "Afficher l'app source",
            "de": "Quell-App anzeigen",
            "es": "Mostrar app de origen",
            "ru": "Показывать исходное приложение",
            "pt": "Mostrar App de Origem"
        ],
        "showSourceAppSubtitle": [
            "en": "Display which app copied the item",
            "zh-Hans": "显示复制该条目的应用",
            "zh-Hant": "顯示複製該項目的應用程式",
            "ja": "アイテムをコピーしたアプリを表示",
            "ko": "항목을 복사한 앱 표시",
            "fr": "Afficher l'application qui a copié l'élément",
            "de": "Anzeigen, welche App den Eintrag kopiert hat",
            "es": "Mostrar qué app copió el elemento",
            "ru": "Показывать, какое приложение скопировало элемент",
            "pt": "Exibir qual app copiou o item"
        ],
        "panelAnimationSpeedTitle": [
            "en": "Animation Speed",
            "zh-Hans": "动画速度",
            "zh-Hant": "動畫速度",
            "ja": "アニメーション速度",
            "ko": "애니메이션 속도",
            "fr": "Vitesse d'animation",
            "de": "Animationsgeschwindigkeit",
            "es": "Velocidad de animación",
            "ru": "Скорость анимации",
            "pt": "Velocidade da Animação"
        ],
        "panelAnimationSpeedSubtitle": [
            "en": "Adjust panel open/close animation pace",
            "zh-Hans": "调整面板打开/关闭动画速度",
            "zh-Hant": "調整面板開啟/關閉動畫速度",
            "ja": "パネルの開閉アニメーション速度を調整",
            "ko": "패널 열기/닫기 애니메이션 속도 조절",
            "fr": "Ajuster la vitesse d'ouverture/fermeture du panneau",
            "de": "Geschwindigkeit der Panel-Öffnungs-/Schließanimation anpassen",
            "es": "Ajustar velocidad de apertura/cierre del panel",
            "ru": "Настроить скорость анимации открытия/закрытия панели",
            "pt": "Ajustar velocidade de abertura/fechamento do painel"
        ],
        "notificationDurationTitle": [
            "en": "Notification Duration",
            "zh-Hans": "通知时长",
            "zh-Hant": "通知時長",
            "ja": "通知表示時間",
            "ko": "알림 지속 시간",
            "fr": "Durée des notifications",
            "de": "Benachrichtigungsdauer",
            "es": "Duración de notificaciones",
            "ru": "Длительность уведомлений",
            "pt": "Duração da Notificação"
        ],
        "notificationDurationSubtitle": [
            "en": "How long toast alerts stay visible",
            "zh-Hans": "弹窗提醒显示多久",
            "zh-Hant": "彈窗提醒顯示多久",
            "ja": "トースト通知の表示時間",
            "ko": "토스트 알림 표시 시간",
            "fr": "Temps d'affichage des alertes toast",
            "de": "Wie lange Toast-Benachrichtigungen sichtbar bleiben",
            "es": "Cuánto tiempo permanecen visibles las alertas toast",
            "ru": "Как долго отображаются тост-уведомления",
            "pt": "Quanto tempo os alertas toast permanecem visíveis"
        ],
        "searchCaseSensitiveTitle": [
            "en": "Case-Sensitive Search",
            "zh-Hans": "区分大小写搜索",
            "zh-Hant": "區分大小寫搜尋",
            "ja": "大文字と小文字を区別して検索",
            "ko": "대소문자 구분 검색",
            "fr": "Recherche sensible à la casse",
            "de": "Groß-/Kleinschreibung beachten",
            "es": "Búsqueda sensible a mayúsculas",
            "ru": "Поиск с учётом регистра",
            "pt": "Pesquisa Diferenciando Maiúsculas"
        ],
        "searchCaseSensitiveSubtitle": [
            "en": "Match exact letter case when searching history",
            "zh-Hans": "搜索历史时精确匹配字母大小写",
            "zh-Hant": "搜尋歷史時精確匹配字母大小寫",
            "ja": "履歴検索時に大文字と小文字を正確に一致",
            "ko": "기록 검색 시 대소문자 정확히 일치",
            "fr": "Respecter la casse lors de la recherche dans l'historique",
            "de": "Bei Verlaufssuche exakte Groß-/Kleinschreibung verwenden",
            "es": "Coincidir mayúsculas/minúsculas al buscar en historial",
            "ru": "Точное совпадение регистра при поиске в истории",
            "pt": "Coincidir maiúsculas/minúsculas ao pesquisar histórico"
        ],
        "pasteDelayTitle": [
            "en": "Paste Delay",
            "zh-Hans": "粘贴延迟",
            "zh-Hant": "貼上延遲",
            "ja": "貼り付け遅延",
            "ko": "붙여넣기 지연",
            "fr": "Délai de collage",
            "de": "Einfügeverzögerung",
            "es": "Retraso al pegar",
            "ru": "Задержка вставки",
            "pt": "Atraso ao Colar"
        ],
        "pasteDelaySubtitle": [
            "en": "Wait before simulating paste keystrokes",
            "zh-Hans": "模拟粘贴按键前的等待时间",
            "zh-Hant": "模擬貼上按鍵前的等待時間",
            "ja": "貼り付けキー入力をシミュレートする前の待機時間",
            "ko": "붙여넣기 키 입력 시뮬레이션 전 대기 시간",
            "fr": "Attendre avant de simuler les frappes de collage",
            "de": "Wartezeit vor Simulation der Einfügetasten",
            "es": "Esperar antes de simular pulsaciones de pegado",
            "ru": "Ожидание перед имитацией нажатий вставки",
            "pt": "Aguardar antes de simular teclas de colar"
        ],
        "okButton": [
            "en": "OK",
            "zh-Hans": "确定",
            "zh-Hant": "確定",
            "ja": "OK",
            "ko": "확인",
            "fr": "OK",
            "de": "OK",
            "es": "Aceptar",
            "ru": "OK",
            "pt": "OK"
        ]
    ]
}
