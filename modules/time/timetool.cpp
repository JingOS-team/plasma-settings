#include "timetool.h"
#include <QDebug>
#include <QDBusConnection>

TimeTool::TimeTool(QObject *parent)
    : QObject(parent)
{
    init();
}

TimeTool::~TimeTool()
{
}

void TimeTool::init(){
    registSysDlgAction();
}

void TimeTool::registSysDlgAction(){    
    
    bool rv = QDBusConnection::sessionBus().connect(QString(),QString("/org/kde/Polkit1AuthAgent"), 
        "org.kde.Polkit1AuthAgent",                                                    
        "sigCancel", this, 
        SLOT(slotReceiveDbusCancel())
        );    

    if (rv == false){        
        qWarning() << "dbus connect sigCancel fail";    
    }

    bool rv1 = QDBusConnection::sessionBus().connect(QString(), 
    QString("/org/kde/Polkit1AuthAgent"), 
        "org.kde.Polkit1AuthAgent",
        "sigConfirm", 
        this, 
        SLOT(slotReceiveDbusConfirm()));  

    if (rv1 == false){        
        qWarning() << "dbus connect sigConfirm fail";    
    } else {
        qWarning() << "dbus connect sigConfirm OK";    
    }
          
}

void TimeTool::slotReceiveDbusCancel(){
    dlgCancel();
}

void TimeTool::slotReceiveDbusConfirm(){
    dlgConfirm();
}