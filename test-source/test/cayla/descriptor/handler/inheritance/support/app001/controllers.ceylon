import io.cayla.web { Handler }
shared abstract class AbstractIndex() extends Handler() {
}
shared class Index(shared String s) extends AbstractIndex() {
}
