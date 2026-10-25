package net.bigpoint.darkorbit.map.model.minimap
{
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.Interference;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.minimap.HeroMiniMapTrait;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.LayeredSprite;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MiniMap extends Sprite
   {
      
      private static const MINIMAP_SCALE_MIN:Number = 3;
      
      private static const MINIMAP_SCALE_MAX:Number = 11;
      
      private var _hero:Ship;
      
      public const resized:ISignal = new Signal();
      
      public const clicked:ISignal = new Signal();
      
      private var _map:Map;
      
      private var _entitiesProvider:EntityTraitContainer;
      
      private var zoomFactor:Number;
      
      private var _scaleFactor:Number = 8;
      
      private var _destinationMarker:MovieClip;
      
      private var _entitiesContainer:LayeredSprite;
      
      private var _clickMap:Sprite = new Sprite();
      
      private var mapLabel:TextField = new TextField();
      
      private var coordinatesLabel:TextField = new TextField();
      
      private var routeInfoLabel:TextField = new TextField();
      
      private var _miniMapWidth:int = 0;
      
      private var _miniMapHeight:int = 0;
      
      private const yOffset:int = 27;
      
      private const mapInfoY:int = 9;
      
      private var finisher:SWFFinisher;
      
      private var mapID:int;
      
      private var mapName:String;
      
      private var mapNameWidth:int;
      
      private var maxNeededCooWidth:int;
      
      private var threatObject:Shape;
      
      private var overlay:MovieClip;
      
      private var combinedScaleFactor:Number;
      
      private var indicatorColors:Array = [16777215,16772505,16767296,16763955,16751360,16737792];
      
      private var interference:Interference;
      
      private var _background:MiniMapBackground = new MiniMapBackground();
      
      public function MiniMap()
      {
         super();
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("minimap"));
         this.overlay = this.finisher.getEmbeddedMovieClip("minimapOverlay");
         this.overlay.mouseEnabled = false;
         this.overlay.y = this.yOffset;
         this.initBackground();
         this.initMapInfoLabel(this.mapLabel);
         this.initMapInfoLabel(this.coordinatesLabel);
         this.coordinatesLabel.text = "999/999";
         this.maxNeededCooWidth = int(this.coordinatesLabel.width) + 2;
         this.coordinatesLabel.text = "";
         this.initMapInfoLabel(this.routeInfoLabel);
         addChild(this.overlay);
         Settings.displayMiniMapBackgroundImage.changed.add(this.updateSize);
         Settings.enemyCount.changed.add(this.updateThreatIndicator);
         this.updateThreatIndicator();
      }
      
      public function set map(param1:Map) : void
      {
         MapMarker.cleanupAllMarkers();
         if(this._entitiesProvider)
         {
            this._entitiesProvider.traitAdded.remove(this.newMinimapTraitAdded);
            this._entitiesProvider.traitRemoved.remove(this.newMinimapTraitRemoved);
            this._map.getShipManager().heroChanged.remove(this.handleHeroChanged);
         }
         this._map = param1;
         if(this._map)
         {
            this._entitiesProvider = this._map.getTraitsList(AbstractMiniMapTrait);
            this._entitiesProvider.traitAdded.add(this.newMinimapTraitAdded);
            this._entitiesProvider.traitRemoved.add(this.newMinimapTraitRemoved);
            this._map.getShipManager().heroChanged.add(this.handleHeroChanged);
         }
         this.scaleFactor = this.scaleFactor;
         this.handleHeroChanged();
      }
      
      private function handleHeroChanged(param1:Ship = null) : void
      {
         if(this._hero)
         {
            this._hero.position.changed.remove(this.handleHeroMove);
         }
         this._hero = this.map ? this.map.hero : null;
         if(this._hero)
         {
            this._hero.position.changed.add(this.handleHeroMove);
            this.handleHeroMove();
         }
      }
      
      public function get map() : Map
      {
         return this._map;
      }
      
      public function set scaleFactor(param1:Number) : void
      {
         this._scaleFactor = Math.min(Math.max(param1,MINIMAP_SCALE_MIN),MINIMAP_SCALE_MAX);
         if(this._map)
         {
            this.zoomFactor = this._scaleFactor * this._map.scaleFactor;
         }
         this.combinedScaleFactor = 1 / (this.zoomFactor * 10);
         this.updateSize();
      }
      
      public function get scaleFactor() : Number
      {
         return this._scaleFactor;
      }
      
      public function zoomIn() : void
      {
         this.scaleFactor = this._scaleFactor - 1;
      }
      
      public function zoomOut() : void
      {
         this.scaleFactor = this._scaleFactor + 1;
      }
      
      public function get hero() : Ship
      {
         return this._hero;
      }
      
      public function startInterference(param1:int) : void
      {
         if(this.interference != null)
         {
            this.interference.cleanup();
         }
         this.interference = new Interference(this._miniMapWidth,this._miniMapHeight);
         this.interference.duration = param1;
         this.interference.alpha = 0.2;
         this.interference.start();
         this.interference.mouseChildren = false;
         this.interference.mouseEnabled = false;
         this.interference.y = this.yOffset;
         addChild(this.interference);
      }
      
      public function updateThreatIndicator() : void
      {
         var _loc1_:int = Math.max(0,Math.min(Settings.enemyCount.value,5));
         var _loc2_:int = 6;
         var _loc3_:Number = this._miniMapHeight / (_loc2_ - 1);
         var _loc4_:uint = uint(this.indicatorColors[_loc1_]);
         if(this.threatObject == null)
         {
            this.threatObject = new Shape();
         }
         else
         {
            this.threatObject.graphics.clear();
         }
         this.threatObject.graphics.beginFill(_loc4_);
         this.threatObject.graphics.drawRect(0,(5 - _loc1_) * _loc3_,3,_loc3_ * _loc1_);
         this.threatObject.graphics.lineStyle(1,10079487);
         this.threatObject.graphics.moveTo(8,0);
         this.threatObject.graphics.lineTo(8,this._miniMapHeight);
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            if(_loc6_ == _loc2_ - 1)
            {
               _loc5_--;
            }
            this.threatObject.graphics.moveTo(4,_loc5_);
            this.threatObject.graphics.lineTo(10,_loc5_);
            _loc5_ += _loc3_;
            _loc6_++;
         }
         _loc5_ = 0;
         _loc2_ = 21;
         _loc3_ = this._miniMapHeight / (_loc2_ - 1);
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            if(_loc6_ == _loc2_ - 1)
            {
               _loc5_--;
            }
            this.threatObject.graphics.lineTo(9,_loc5_);
            _loc5_ += _loc3_;
            _loc6_++;
         }
         if(this._miniMapHeight == 0)
         {
            return;
         }
         addChild(this.threatObject);
         this.threatObject.x = -this.threatObject.width;
         this.threatObject.y = this.yOffset;
      }
      
      private function initMapInfoLabel(param1:TextField) : void
      {
         param1.defaultTextFormat = Styles.h3Fmt;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.textColor = 16777215;
         param1.embedFonts = Styles.h3Embed;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.selectable = false;
         param1.mouseEnabled = false;
         param1.y = this.mapInfoY;
         if(!contains(param1))
         {
            addChild(param1);
         }
      }
      
      private function handleHeroMove() : void
      {
         this.updateCoordinates();
      }
      
      private function updateCoordinates() : void
      {
         var _loc1_:Number = NaN;
         if(this.hero != null)
         {
            this.writeMapName();
            this.coordinatesLabel.x = this.mapNameWidth + this.mapLabel.x;
            this.coordinatesLabel.text = int(this.hero.position.x / 100) + "/" + int(this.hero.position.y / 100);
            this.routeInfoLabel.text = "";
            if(this.hero.moveTrait.isMoving)
            {
               _loc1_ = this.hero.position.subtract(this.hero.moveTrait.destination).length / 100;
               this.routeInfoLabel.text = "> " + BPLocale.getItem("travelling_distance").replace(/%DIST%/,TextFormatter.round(_loc1_,2));
            }
            else
            {
               this.routeInfoLabel.text = "";
            }
            if(Boolean(this._destinationMarker) && Boolean(this._destinationMarker.visible) && Boolean(this.hero.moveTrait.destination))
            {
               this._destinationMarker.x = this.hero.moveTrait.destination.x * this.combinedScaleFactor;
               this._destinationMarker.y = this.hero.moveTrait.destination.y * this.combinedScaleFactor;
            }
         }
      }
      
      private function writeMapName() : void
      {
         if(this.mapID != this.map.getMapID())
         {
            this.mapID = this.map.getMapID();
            this.mapName = this.map.getName();
            this.mapLabel.text = this.mapName;
            this.mapNameWidth = int(this.mapLabel.width) + 2;
            this.routeInfoLabel.x = this.mapNameWidth + this.mapLabel.x + this.maxNeededCooWidth;
         }
      }
      
      private function initBackground() : void
      {
         this._entitiesContainer = new LayeredSprite();
         this._entitiesContainer.y = this.yOffset;
         addChild(this._entitiesContainer);
         this._clickMap.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         this._clickMap.buttonMode = true;
         this._clickMap.y = this.yOffset;
         addChild(this._clickMap);
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this.showDestinationMarker();
         this.handleMouseDrag();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseDrag);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
      }
      
      private function showDestinationMarker(param1:Number = 1) : void
      {
         if(this._destinationMarker == null)
         {
            this._destinationMarker = this.finisher.getEmbeddedMovieClip("minimapPointer");
            this._entitiesContainer.getLayer(int.MAX_VALUE).addChild(this._destinationMarker);
            this._destinationMarker.mouseEnabled = this._destinationMarker.mouseChildren = false;
         }
         TweenLite.killTweensOf(this._destinationMarker);
         this._destinationMarker.gotoAndStop(1);
         this._destinationMarker.scaleX = this._destinationMarker.scaleY = param1;
         this._destinationMarker.visible = true;
         if(this.hero)
         {
            HeroMiniMapTrait(this.hero.getFirstTrait(HeroMiniMapTrait)).destinationMarkerVisible = true;
         }
      }
      
      private function hideDestinationMarker() : void
      {
         var _loc1_:Number = NaN;
         if(this._destinationMarker)
         {
            _loc1_ = this._destinationMarker.totalFrames / (stage.frameRate / 2);
            TweenLite.to(this._destinationMarker,_loc1_,{
               "frame":this._destinationMarker.totalFrames,
               "onComplete":this.removeDestionationMarker
            });
         }
      }
      
      private function removeDestionationMarker() : void
      {
         this._destinationMarker.visible = false;
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseDrag);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.hideDestinationMarker();
      }
      
      private function handleMouseDrag(param1:MouseEvent = null) : void
      {
         var _loc2_:int = this._clickMap.mouseX * this.zoomFactor * 10;
         var _loc3_:int = this._clickMap.mouseY * this.zoomFactor * 10;
         this.clicked.dispatch(_loc2_,_loc3_);
      }
      
      private function updateSize() : void
      {
         var _loc2_:AbstractMiniMapTrait = null;
         if(this.map == null)
         {
            return;
         }
         this._miniMapWidth = Math.round(this.map.serious_width / this.zoomFactor * 0.1);
         this._miniMapHeight = Math.round(this.map.serious_height / this.zoomFactor * 0.1);
         this._clickMap.graphics.clear();
         this._clickMap.graphics.lineStyle(1,0,0);
         this._clickMap.graphics.beginFill(0,0.2);
         this._clickMap.graphics.drawRect(0,0,this._miniMapWidth,this._miniMapHeight);
         this._clickMap.graphics.endFill();
         this.overlay.width = this._miniMapWidth;
         this.overlay.height = this._miniMapHeight;
         var _loc1_:Vector.<EntityTraitBase> = this._entitiesProvider.traits;
         this._entitiesContainer.removeAll();
         this._background.update(this._map,this.miniMapWidth,this.miniMapHeight);
         this._entitiesContainer.addChildOnLayer(this._background,int.MIN_VALUE);
         if(this._destinationMarker)
         {
            this._entitiesContainer.getLayer(int.MAX_VALUE).addChild(this._destinationMarker);
         }
         for each(_loc2_ in _loc1_)
         {
            this._entitiesContainer.addChildOnLayer(_loc2_.getMiniMapIcon(this.combinedScaleFactor,this._miniMapWidth,this._miniMapHeight),_loc2_.layer);
         }
         this._entitiesContainer.scrollRect = new Rectangle(0,0,this._miniMapWidth,this._miniMapHeight);
         this.updateThreatIndicator();
         this.resized.dispatch();
      }
      
      private function newMinimapTraitAdded(param1:AbstractMiniMapTrait) : void
      {
         this._entitiesContainer.addChildOnLayer(param1.getMiniMapIcon(this.combinedScaleFactor,this.miniMapWidth,this.miniMapHeight),param1.layer);
      }
      
      private function newMinimapTraitRemoved(param1:AbstractMiniMapTrait) : void
      {
         this._entitiesContainer.removeChildFromAllLayers(param1.getMiniMapIcon(this.combinedScaleFactor,this.miniMapWidth,this.miniMapHeight));
      }
      
      public function addMapMarker(param1:MarkerVO) : void
      {
         var _loc2_:MapMarker = new MapMarker(param1,this.zoomFactor,this.combinedScaleFactor);
         this._entitiesContainer.addChildOnLayer(_loc2_,int.MAX_VALUE);
      }
      
      public function get miniMapWidth() : int
      {
         return this._miniMapWidth;
      }
      
      public function get miniMapHeight() : int
      {
         return this._miniMapHeight;
      }
   }
}

