package net.bigpoint.darkorbit.map.view2D.backgrounds.view
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.PlanetVO;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.IDisplayObject;
   import net.bigpoint.darkorbit.settings.Settings;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.events.Event;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.textures.TextureOptions;
   
   public class Planet2D extends AbstractBackgroundElement2D
   {
      
      private var _planetVO:PlanetVO;
      
      private var _collider:BitmapData = null;
      
      private var _colliderScaleX:Number = 1;
      
      private var _colliderScaleY:Number = 1;
      
      private var _texture:Texture;
      
      private var _planet:Object;
      
      private var _qualitySettings:BindableBoolean;
      
      public function Planet2D(param1:IDOSprite, param2:PlanetVO)
      {
         super(param1 as IDisplayObject,param2);
         this._planetVO = param2;
         param1.rotationDeg = this._planetVO.rotation;
         param1.scaleX = this._planetVO.scale;
         param1.scaleY = this._planetVO.scale;
         param1.alpha = 0;
         this._qualitySettings = Settings3D.getEffectsQualityFromLookup(this._planetVO.getQualitySettings);
         if(this._qualitySettings)
         {
            this._qualitySettings.changed.add(handleBackgroundQualityChanged);
         }
      }
      
      override public function update(param1:int, param2:int, param3:int, param4:int) : void
      {
         view.x = (this._planetVO.x - param1) / this._planetVO.parallaxFactor + param3;
         view.y = (this._planetVO.y - param2) / this._planetVO.parallaxFactor + param4;
      }
      
      public function get planetVO() : PlanetVO
      {
         return this._planetVO;
      }
      
      override public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         var _loc3_:uint = 0;
         if(this._collider)
         {
            _loc3_ = this._collider.getPixel32((param1 - view.x + int(view.width >> 1)) * this._colliderScaleX,(param2 - view.y + int(view.height >> 1)) * this._colliderScaleY);
            return _loc3_ >>> 24 > 128;
         }
         return false;
      }
      
      override protected function loadView() : void
      {
         if(Starling.current)
         {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
         }
         var _loc1_:String = this.planetVO.pattern.resKey;
         if(Settings.useATF && ResourceManager.fileCollection.fileExists(_loc1_ + "_atf"))
         {
            _loc1_ += "_atf";
         }
         ResourceManager.fileCollection.load(_loc1_,this.handleResourceReady);
      }
      
      override protected function unloadView() : void
      {
         if(Starling.current)
         {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
         }
         if(this._collider)
         {
            this._collider.dispose();
            this._collider = null;
         }
         if(this._texture)
         {
            if(this._texture is ConcreteTexture)
            {
               ConcreteTexture(this._texture).onRestore = null;
            }
            this._texture.dispose();
            this._texture = null;
         }
         TweenLite.killTweensOf(view);
         super.unloadView();
      }
      
      override protected function meetsQualitySettings() : Boolean
      {
         if(this._qualitySettings)
         {
            return this._qualitySettings.value;
         }
         return Settings.qualityBackground.value >= Settings.QUALITY_GOOD;
      }
      
      override public function dispose() : void
      {
         if(this._qualitySettings)
         {
            this._qualitySettings.changed.remove(handleBackgroundQualityChanged);
         }
         super.dispose();
      }
      
      private function handleResourceReady(param1:FileCollectionFinisher) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:TextureOptions = null;
         if(!this.meetsQualitySettings())
         {
            return;
         }
         if(Settings.gpuSupport)
         {
            if(param1 is DefaultFinisher)
            {
               _loc2_ = DefaultFinisher(param1).data as ByteArray;
            }
            if(Boolean(Starling.context) && Starling.context.driverInfo != "Disposed")
            {
               if(this._texture)
               {
                  this._texture.root.uploadAtfData(_loc2_ as ByteArray,0);
               }
               else
               {
                  _loc3_ = new TextureOptions();
                  _loc3_.onReady = this.initPlanetView;
                  this._texture = Texture.fromData(_loc2_,_loc3_);
                  ConcreteTexture(this._texture).onRestore = this.loadView;
                  this._planet = new Image(this._texture);
               }
            }
            else
            {
               Starling.current.addEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
            }
            param1.dispose();
         }
         else
         {
            if(param1 is ImageFinisher)
            {
               this._planet = new Bitmap(ImageFinisher(param1).getBitmap().bitmapData);
            }
            this.initPlanetView();
            GameFacade.getInstance().sendNotification(AssetNotifications.ADD_UNLOAD_FINISHER,param1);
         }
         this.initCollider(param1);
      }
      
      private function initPlanetView() : void
      {
         TweenLite.killTweensOf(view);
         if(this._planet)
         {
            this._planet.x = -int(this._planet.width >> 1);
            this._planet.y = -int(this._planet.height >> 1);
            view.addUntypedChild(this._planet);
            TweenLite.to(view,0.5,{"alpha":1});
         }
      }
      
      private function initCollider(param1:FileCollectionFinisher) : void
      {
         var _loc2_:String = null;
         if(this._collider == null && this._planetVO.pattern.radius >= 0)
         {
            _loc2_ = this.planetVO.pattern.resKey + "_collider";
            if(ResourceManager.fileCollection.fileExists(_loc2_))
            {
               ResourceManager.fileCollection.load(_loc2_,this.handleColliderReady);
            }
         }
      }
      
      private function handleColliderReady(param1:ImageFinisher) : void
      {
         this._collider = param1.getBitmap().bitmapData.clone();
         this._colliderScaleX = this._collider.width / view.width;
         this._colliderScaleY = this._collider.height / view.height;
         param1.dispose();
      }
      
      private function handleContextCreate(param1:Event) : void
      {
         Starling.current.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
         this.loadView();
      }
   }
}

