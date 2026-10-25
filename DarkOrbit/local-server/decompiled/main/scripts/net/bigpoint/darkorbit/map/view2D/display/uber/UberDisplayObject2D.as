package net.bigpoint.darkorbit.map.view2D.display.uber
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IStateAware;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UberDisplayObject2D extends Sprite implements IStateAware
   {
      
      public const ready:ISignal = new Signal();
      
      private var _display2D:XML;
      
      private var _asset:DisplayObject;
      
      private var _includeIn:Vector.<String>;
      
      private var _debug:Boolean;
      
      private var _srcKey:String;
      
      public function UberDisplayObject2D(param1:XML = null, param2:Boolean = false)
      {
         super();
         this._display2D = param1 || new XML();
         this._debug = param2;
         if(this._display2D.attribute("includeIn").length() > 0)
         {
            this._includeIn = Vector.<String>(String(this._display2D.@includeIn).split(","));
         }
      }
      
      public function init() : void
      {
         var _loc1_:String = String(this._display2D.@srcKey);
         var _loc2_:String = String(this._display2D.@resKey);
         if(_loc1_.length > 0)
         {
            this.load(_loc1_,_loc2_ || "mc");
         }
         else
         {
            setTimeout(this.ready.dispatch,1);
         }
      }
      
      public function load(param1:String, param2:String) : void
      {
         this._srcKey = param1;
         if(param1)
         {
            GameFacade.getInstance().sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.handleViewLoadComplete,param1,Vector.<String>([param2]),String(this._display2D.@useBitmapClip) == "true" ? BitmapClip : DisplayObject));
         }
         else
         {
            ResourceManager.fileCollection.load(param2,this.handleResourceLoadComplete);
         }
      }
      
      private function handleViewLoadComplete(param1:Object) : void
      {
         this.asset = param1 as DisplayObject;
      }
      
      private function handleResourceLoadComplete(param1:FileCollectionFinisher) : void
      {
         if(param1 is ImageFinisher)
         {
            this.asset = ImageFinisher(param1).getBitmap();
         }
         else if(param1 is SWFFinisher)
         {
            this.asset = SWFFinisher(param1).getAsDisplayObject();
         }
      }
      
      public function set asset(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         MovieClipUtils.removeDisplayObject(this._asset);
         this._asset = param1;
         if(this._asset)
         {
            this._asset.name = "content";
            if(String(this._display2D.@center) == "true")
            {
               this._asset.x -= this._asset.width >> 1;
               this._asset.y -= this._asset.height >> 1;
            }
            if(this._asset is MovieClip)
            {
               _loc2_ = int(int(this._display2D.@frame) || 1);
               if(String(this._display2D.@autoPlay) == "false")
               {
                  MovieClip(this._asset).gotoAndStop(_loc2_);
               }
               else
               {
                  MovieClip(this._asset).gotoAndPlay(_loc2_);
               }
            }
            addChildAt(this._asset,0);
         }
         setTimeout(this.ready.dispatch,1);
      }
      
      public function handleStateChange(param1:String) : void
      {
         visible = this._includeIn == null || this._includeIn.indexOf(param1) != -1;
      }
      
      public function get asset() : DisplayObject
      {
         return this._asset;
      }
      
      public function get srcKey() : String
      {
         return this._srcKey;
      }
   }
}

