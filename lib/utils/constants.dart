class Constants {
  static const baseUrl = "http://192.168.60.161:8000";
  static const loginUrl = '$baseUrl/login/'; //colocar / para evitar 307
  static const cadastroUrl = '$baseUrl/usuario/';
  static const tokenStatus = '$baseUrl/login/token/status';

  // static const listaAnunciosPaginacao = '$baseUrl/anuncios/?raio=40&page=';

  String listaAnunciosPaginacao(int raio, int pageKey, int categoria) {
    String lista =
        '$baseUrl/anuncios/?raio=$raio&categoria=$categoria&page=$pageKey';
    return lista;
  }

  String listaAnunciosUsuarioPaginacao(int pageKey) {
    String lista = '$baseUrl/anuncios/usuario/eu/?page=$pageKey';
    return lista;
  }

  String deletaAnuncio(int idNum) {
    String deleta = '$baseUrl/anuncios/$idNum';
    return deleta;
  }

  static const listaAnuncios = '$baseUrl/anuncios/?raio=40&page=1';

///////////////// Conversas //////////////////

  static const criaConversa = '$baseUrl/conversas/cria';

  static const listaConversas = '$baseUrl/conversas/';

  String listaConversasPaginacao(int pageKey) {
    String lista = '$baseUrl/conversas/?page=$pageKey';
    return lista;
  }

  String getConversaDetalhada(int idNum) {
    String mostraConversa = '$baseUrl/conversas/$idNum/mensagens';
    return mostraConversa;
  }

  String getEnviaMensagem(String idNum) {
    String enviaMensagem = '$baseUrl/conversas/$idNum/mensagens';
    return enviaMensagem;
  }

  String verificaAnuncioFavoritoPeloId(String idNum) {
    String verificaFavorito = '$baseUrl/usuario/favoritos/$idNum';
    return verificaFavorito;
  }

  static const adicionaFavorito = '$baseUrl/usuario/favoritos/adiciona';

  String removeFavoritos(String idNum) {
    String remove = '$baseUrl/usuario/favoritos/remove/$idNum';
    return remove;
  }

  static const cadastrarAnuncio = '$baseUrl/anuncios/';

  static const usuarioFavoritos = '$baseUrl/usuario/favoritos';

  static const listCategorias = '$baseUrl/categorias/';

  // String getCategoria(String idNum) {
  //   String categoriaDetalhe = '$baseUrl/categorias/$idNum';
  //   return categoriaDetalhe;
  // }

  String getlistaAnunciosPaginacao(String raio) {
    String listaAnunciosPaginacao = '$baseUrl/anuncios/?raio=$raio&page=';
    return listaAnunciosPaginacao;
  }
}
