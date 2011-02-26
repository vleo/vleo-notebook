#include   <libxml/xmlmemory.h>
#include   <libxml/parser.h>

int main()
{
  xmlDocPtr doc;
  xmlChar *xmlBuf;
  int xmlBufSize;
  doc = xmlNewDoc(BAD_CAST "1.0");
  xmlDocDumpFormatMemory(doc, &xmlBuf, &xmlBufSize, 1);
  printf("XML: size:%d\n%s\n",xmlBufSize,(char*)xmlBuf);
  xmlFree(xmlBuf);
  xmlFreeDoc(doc);

  xmlCleanupCharEncodingHandlers();
  xmlCleanupParser();

}
