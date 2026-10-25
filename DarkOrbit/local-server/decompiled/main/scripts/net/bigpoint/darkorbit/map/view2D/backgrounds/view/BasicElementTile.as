package net.bigpoint.darkorbit.map.view2D.backgrounds.view
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.TexturesCache;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.events.Event;
   import starling.textures.ConcreteTexture;
   import starling.textures.SubTexture;
   import starling.textures.Texture;
   import starling.textures.TextureOptions;
   
   public class BasicElementTile
   {
      
      private var _resKey:String;
      
      private var _container:Object;
      
      private var _resource:Object;
      
      private var _texture:Texture;
      
      private var _disposed:Boolean = false;
      
      private var _offsetX:int = 0;
      
      private var _offsetY:int = 0;
      
      private var _region:Rectangle;
      
      public function BasicElementTile(param1:String, param2:Object, param3:int = 0, param4:int = 0, param5:Rectangle = null)
      {
         super();
         this._resKey = param1;
         this._container = param2;
         this._offsetX = param3;
         this._offsetY = param4;
         this._region = param5;
         this.loadView();
      }
      
      public function loadView() : void
      {
         this._disposed = false;
         if(Starling.current)
         {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
         }
         var _loc1_:String = this._resKey;
         if(Settings.useATF && ResourceManager.fileCollection.fileExists(_loc1_ + "_atf"))
         {
            _loc1_ += "_atf";
         }
         ResourceManager.fileCollection.load(_loc1_,this.handleResourceReady);
      }
      
      public function unloadView() : void
      {
         if(Starling.current)
         {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
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
         if(this._resource)
         {
            TweenLite.killTweensOf(this._resource);
            this._container.removeUntypedChild(this._resource);
            if("dispose" in this._resource && this._resource.dispose is Function)
            {
               this._resource.dispose();
            }
            this._resource = null;
         }
         this._disposed = true;
      }
      
      private function handleResourceReady(param1:FileCollectionFinisher) : void
      {
         var textureData:ByteArray = null;
         var options:TextureOptions = null;
         var source:Bitmap = null;
         var finisher:FileCollectionFinisher = param1;
         if(this._disposed)
         {
            return;
         }
         if(Settings.gpuSupport)
         {
            if(finisher is DefaultFinisher)
            {
               textureData = DefaultFinisher(finisher).data as ByteArray;
            }
            if(Boolean(Starling.context) && Starling.context.driverInfo != "Disposed")
            {
               if(this._texture)
               {
                  TexturesCache.reupload(this._texture,textureData);
               }
               else
               {
                  options = new TextureOptions();
                  options.onReady = this.initResource;
                  try
                  {
                     this._texture = new SubTexture(Texture.fromData(textureData,options),this._region,true);
                     ConcreteTexture(this._texture.root).onRestore = this.loadView;
                     this._resource = new Image(this._texture);
                  }
                  catch(e:Error)
                  {
                     EventStreamClient.track("flash.warning",{
                        "message":"BasicElementTile texture error",
                        "errorMessage":e.message,
                        "errorID":e.errorID,
                        "resKey":_resKey
                     });
                  }
               }
            }
            else
            {
               Starling.current.addEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
            }
         }
         else
         {
            if(finisher is ImageFinisher)
            {
               source = ImageFinisher(finisher).getBitmap();
               this._resource = new Bitmap(source.bitmapData,source.pixelSnapping,source.smoothing);
               this.initResource();
            }
            GameFacade.getInstance().sendNotification(AssetNotifications.ADD_UNLOAD_FINISHER,finisher);
         }
      }
      
      private function handleContextCreate(param1:Event) : void
      {
         Starling.current.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContextCreate);
         this.loadView();
      }
      
      private function initResource() : void
      {
         if(this._disposed)
         {
            return;
         }
         if(this._resource)
         {
            this._resource.x = this._offsetX;
            this._resource.y = this._offsetY;
            this._container.addUntypedChild(this._resource);
            this._resource.alpha = 0;
            TweenLite.to(this._resource,1,{"alpha":1});
         }
      }
   }
}

