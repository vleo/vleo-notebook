#include "nonblockserver.h"
#include <QApplication>

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	nonBlockServer w;
	w.show();
	return a.exec();
}
