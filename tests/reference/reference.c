/* Differential-test oracle: uses the original C implementation only. */
#include "md4c.h"
#include <stdio.h>
#include <stdlib.h>
static void bd(MD_BLOCKTYPE, void*); static void sd(MD_SPANTYPE, void*);
static int be(MD_BLOCKTYPE t, void* d, void* u) { printf("B+ %d\n", t); bd(t,d); return 0; }
static int bl(MD_BLOCKTYPE t, void* d, void* u) { printf("B- %d\n", t); bd(t,d); return 0; }
static int se(MD_SPANTYPE t, void* d, void* u) { printf("S+ %d\n", t); sd(t,d); return 0; }
static int sl(MD_SPANTYPE t, void* d, void* u) { printf("S- %d\n", t); sd(t,d); return 0; }
static int tx(MD_TEXTTYPE t, const MD_CHAR* s, MD_SIZE n, void* u) {
 unsigned i; printf("T %d ", t);
 for(i=0; i<n; i++) printf("%02x", (unsigned char)s[i]);
 putchar('\n'); return 0;
}
int main(int argc, char** argv) {
 FILE* f = fopen(argv[1], "rb"); long n; char* s; int ret;
 MD_PARSER p = {0}; if(!f) return 2;
 fseek(f,0,SEEK_END); n=ftell(f); rewind(f);
 s=malloc(n+1); if(!s) return 2; fread(s,1,n,f); fclose(f);
 p.flags=argc>2 ? strtoul(argv[2],NULL,10) : 0;
 p.enter_block=be; p.leave_block=bl; p.enter_span=se; p.leave_span=sl; p.text=tx;
 ret=md_parse(s,(MD_SIZE)n,&p,NULL); free(s); return ret;
}
static void at(MD_ATTRIBUTE a) {
 unsigned i; printf("A ");
 for(i=0;i<a.size;i++) printf("%02x",(unsigned char)a.text[i]);
 for(i=0;a.size>0 && a.substr_offsets[i]<a.size;i++) printf(" %d:%u",a.substr_types[i],a.substr_offsets[i]);
 printf(" %u\n",a.size);
}
static void bd(MD_BLOCKTYPE t, void* p) {
 switch(t) {
 case MD_BLOCK_H: { MD_BLOCK_H_DETAIL* d=p; printf("D %u\n",d->level); break; }
 case MD_BLOCK_UL: { MD_BLOCK_UL_DETAIL* d=p; printf("D %d %d\n",d->is_tight,d->mark); break; }
 case MD_BLOCK_OL: { MD_BLOCK_OL_DETAIL* d=p; printf("D %u %d %d\n",d->start,d->is_tight,d->mark_delimiter); break; }
 case MD_BLOCK_LI: { MD_BLOCK_LI_DETAIL* d=p; printf("D %d\n",d->is_task); if(d->is_task) printf("D %d %u\n",d->task_mark,d->task_mark_offset); break; }
 case MD_BLOCK_CODE: { MD_BLOCK_CODE_DETAIL* d=p; printf("D %d\n",d->fence_char); at(d->info); at(d->lang); break; }
 case MD_BLOCK_TABLE: { MD_BLOCK_TABLE_DETAIL* d=p; printf("D %u %u %u\n",d->col_count,d->head_row_count,d->body_row_count); break; }
 case MD_BLOCK_TH: case MD_BLOCK_TD: { MD_BLOCK_TD_DETAIL* d=p; printf("D %d\n",d->align); break; }
 case MD_BLOCK_ADMONITION: { MD_BLOCK_ADMONITION_DETAIL* d=p; at(d->type); break; }
 case MD_BLOCK_FOOTNOTE_DEF: { MD_BLOCK_FOOTNOTE_DEF_DETAIL* d=p; printf("D %u %u\n",d->id,d->ref_count); at(d->label); break; }
 case MD_BLOCK_BLANK: { MD_BLOCK_BLANK_DETAIL* d=p; printf("D %u\n",d->line_count); break; }
 default: break;
 }
}
static void sd(MD_SPANTYPE t, void* p) {
 switch(t) {
 case MD_SPAN_A: { MD_SPAN_A_DETAIL* d=p; printf("D %d\n",d->is_autolink); at(d->href); at(d->title); break; }
 case MD_SPAN_IMG: { MD_SPAN_IMG_DETAIL* d=p; at(d->src); at(d->title); break; }
 case MD_SPAN_WIKILINK: { MD_SPAN_WIKILINK_DETAIL* d=p; at(d->target); break; }
 case MD_SPAN_FOOTNOTE_REF: { MD_SPAN_FOOTNOTE_REF_DETAIL* d=p; printf("D %u %u\n",d->id,d->ref_id); at(d->label); break; }
 default: break;
 }
}
