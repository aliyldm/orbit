package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class IconVO extends EventDispatcher
   {
      
      private var _itemVO:ItemVO;
      
      private var _icon:Sprite;
      
      private var _status:int = 0;
      
      private var _resKey:String;
      
      private var assetsProxyString:String;
      
      public function IconVO(param1:ItemVO, param2:Sprite, param3:String = null, param4:String = null)
      {
         super();
         if(param4 == null)
         {
            param4 = AssetsProxy.ITEMS;
         }
         this.reset(param1,param2,param3,param4);
      }
      
      public function get resKey() : String
      {
         return this._resKey;
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function get icon() : Sprite
      {
         return this._icon;
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function reset(param1:ItemVO, param2:Sprite, param3:String = null, param4:String = null) : Boolean
      {
         if(param4 == null)
         {
            param4 = AssetsProxy.ITEMS;
         }
         if(this._status == 1)
         {
            return false;
         }
         this.assetsProxyString = param4;
         this._itemVO = param1;
         this._icon = param2;
         this._resKey = param3;
         if(this.itemVO)
         {
            if(this.resKey == null || this.resKey == "")
            {
               this._resKey = param1.lootID;
            }
            else if("100x100" == param3)
            {
               this._resKey = param1.getLoot100x100();
            }
            else if("30x30" == param3)
            {
               this._resKey = param1.getLoot30x30();
            }
         }
         return true;
      }
      
      public function start() : void
      {
         this._status = 1;
         UISystem.getInstance().uiloader.load(this.resKey,this.resourceLoadedCallback,this.resourceLoadErrorCallback,this.assetsProxyString);
      }
      
      public function stop() : void
      {
         this._status = 0;
      }
      
      private function resourceLoadedCallback(param1:ImageFinisher = null) : void
      {
         var _loc2_:Bitmap = null;
         if(this._status != 0)
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
            _loc2_ = new Bitmap(param1.getBitmap().bitmapData);
            _loc2_.width = this.icon.width;
            _loc2_.height = this.icon.height;
            this.icon.removeChildren();
            this.icon.addChild(_loc2_);
         }
         this._status = 0;
      }
      
      private function resourceLoadErrorCallback(param1:*) : void
      {
         if(this._status != 0)
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this.icon);
            this._status = 0;
            this.dispatchEvent(new IconVOEvent(this));
         }
      }
   }
}

