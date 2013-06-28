package julio.scenegraph
{
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public interface ICena
	{
		function Loading():Boolean;		// Carrega as texturas e Modelos
		function Controle():Boolean;	// Pega e processa as infromações do teclado e mouse
		function Render():Boolean;		// Renderiza a Cena
		
		function Fim():Boolean;			// Destroy a cena e libera memoria
		function Frame():Boolean;		// Prepara a cena pra prox render
		
		function Next():ICena;			// Proxima cena a ser renderizada depois dessa
		function Pausa():Boolean;		// Avisa a cena q ela parará de ser executada, mas nao destruida
		function Continua():Boolean;	// Avisa a cena q ela voltará a ser executada depois de um pause
	}
}