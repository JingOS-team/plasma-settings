#ifndef TIMETOOL_H
#define TIMETOOL_H

#include <QObject>

#include <qapt/globals.h>
#include <QStandardItemModel>
#include <QAbstractListModel>
#include <QGuiApplication>

class TimeTool : public QObject
{
    Q_OBJECT
public:
    TimeTool(QObject *parent = nullptr);
    ~TimeTool();


public Q_SLOTS:
    void init();
    void registSysDlgAction();
    void slotReceiveDbusCancel();
    void slotReceiveDbusConfirm();

signals:
    void dlgConfirm();
    void dlgCancel();    

};

#endif