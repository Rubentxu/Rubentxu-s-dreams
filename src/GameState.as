package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.starling.VirtualJoystick;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.utils.objectmakers.tmx.TmxMap;
	import citrus.view.starlingview.StarlingArt;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class GameState extends StarlingState
	{
		private var _factory:StarlingFactory;
		private var _armature:Armature;
		private var armatureClip:Sprite;
		
		private var seMueve:Boolean;		
		private var agachado:Boolean;
		private var moveDir:int=0;
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		private var ruben:Hero
		private var mando:VirtualJoystick;
		
		
		[Embed(source="/assets/tiledmap/map-atlas.tmx", mimeType="application/octet-stream")]
		private const _Map:Class;
		
		[Embed(source="/assets/tiledmap/Genetica-tiles-atlas.xml", mimeType="application/octet-stream")]
		private const _MapAtlasConfig:Class;
		
		[Embed(source="/assets/tiledmap/Genetica-tiles-atlas.png")]
		private const _MapAtlasPng:Class;		
		
		[Embed(source = "/assets/ruben_personaje_version-1.1_bones.swf", mimeType = "application/octet-stream")]  
		private static const ResourcesData:Class;
		
		public function GameState()
		{
			super();
		}
		override public function initialize():void{
			super.initialize();
			
			_factory = new StarlingFactory();
			_factory.addEventListener(Event.COMPLETE, _textureCompleteHandler);
			_factory.parseData(new ResourcesData());			
			
			var physics:Box2D= new Box2D("box2d");
//			physics.visible=true;
			add(physics);	
			
			
			var bitmap:Bitmap = new _MapAtlasPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _MapAtlasConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			ObjectMakerStarling.FromTiledMap(XML(new _Map()), sTextureAtlas);
			citrus.utils.objectmakers.tmx.TmxMap;
//			(view.getArt(getObjectByName("foreground")) as StarlingArt).alpha = 0.3;
			
			/*var bg:CitrusSprite = new CitrusSprite("BG");
			bg.view = new bgPng();
			add(bg);*/
			
			/*var suelo:Platform= new Platform("suelo",{x:400,y:460,width:2400
				, height:40});
			suelo.view=new Quad(2400,40,0x996666);
			add(suelo);
			var p1:Platform= new Platform("p1",{x:620,y:151,width:300,height:40});
			p1.view=new Quad(300,40,0x66ff99);
			add(p1);
			
			var leftWall:Platform = new Platform("leftWall", {x:0, y:224, width:10, height:stage.stageHeight});
			add(leftWall);
			
			var rightWall:Platform = new Platform("rightWall", {x:1600, y:224, width:10, height:stage.stageHeight});
			add(rightWall);*/
			
			/*var mp:MovingPlatform= new MovingPlatform("moving",
				{x:300, y:360, width:150, height:40, startX:300 ,startY:360, endX:440, endY:151});
			mp.view=new Quad(150,40,0x66ff99);
			add(mp);*/
			

			mando = new VirtualJoystick("joy1");			
			mando.graphic.x=630;		
			mando.graphic.y=390;
			
			
			
		
		}
		
		protected function _textureCompleteHandler(event:Event):void
		{
			_armature = _factory.buildArmature("ruben_personaje");
			armatureClip = _armature.display as Sprite;			
			
			
			ruben = getObjectByName("hero") as Hero;
//			
			ruben.width=50;
			ruben.height=143;
			ruben.view=_armature;
			ruben.acceleration=0.04;
			ruben.maxVelocity=1.6;
			
		
			add(ruben);
			
			view.camera.cameraLensWidth = stage.stageWidth;
			view.camera.cameraLensHeight = stage.stageHeight;			

			view.camera.setUp(ruben, new MathVector(stage.stageWidth / 4, 200), new Rectangle(0, 0, 2400+stage.stageWidth , 640), new MathVector(.5, .5));
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEventHandler);
			
			
		}			
		
		private function onKeyEventHandler(e:KeyboardEvent):void
		{
			
			trace("Keyboard : "+e.keyCode);
			switch (e.keyCode)
			{
				
				case Keyboard.S:
				case Keyboard.DOWN :
			  
					agachado=true;				
					trace("play: agachado");
					break;
			}			
			
		}	
		
		
		private function onEnterFrameHandler():void
		{
			
			updateMove();
			
			_armature.update();
			
			
		}
		
		private function updateMove():void
		{
			trace("Velocidad Movimiento: "+ruben.getWalkingSpeed()	);
			
			
			if(ruben.getWalkingSpeed()!=0 && _armature.animation.movementID!="andar"){
				agachado=false;
				_armature.animation.gotoAndPlay("andar");
				trace("play: andar");
			}
			if(ruben.getWalkingSpeed()==0 && _armature.animation.movementID!="parado" && !agachado){
				agachado=false;
				_armature.animation.gotoAndPlay("parado");
				trace("play: parado");
			}
			if( !ruben.onGround){
				agachado=false;
				_armature.animation.gotoAndPlay("caer");
				trace("play: caer");
			}
			if(agachado && ruben.getWalkingSpeed()==0){
				_armature.animation.gotoAndPlay("agacharse");
			}
			

			trace("IdMovimiento: "+ _armature.animation.movementID);
			//trace("Lista: "+ _armature.animation.movementList);
			
		}		
	
	}
}