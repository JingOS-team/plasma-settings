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
    // MuonSettings::self()->save();
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
            qDebug() <<"绑定系统对话框失败";
        }else {
            qDebug() <<"绑定系统对话框OK";
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
    qDebug() <<"绑定系统对话框 Cancel OK";
    dlgCancel();
}

void TimeTool::slotReceiveDbusConfirm(){
    qDebug() <<"绑定系统对话框 Confirm OK";
    dlgConfirm();
}