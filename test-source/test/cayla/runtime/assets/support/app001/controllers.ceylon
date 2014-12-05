import io.cayla.web { route }
import io.cayla.web.asset { AssetHandler }

route("/assets/*path")
shared class Index(shared String path) extends AssetHandler(path) {
}
