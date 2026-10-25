package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class IconVOLoader
   {
      
      private static var _instance:IconVOLoader;
      
      private var pool:Vector.<IconVO> = new Vector.<IconVO>();
      
      public function IconVOLoader()
      {
         super();
         if(_instance)
         {
            throw new Error("IconVOLoader is a singleton and cannot be instantiated more than once.");
         }
         _instance = this;
      }
      
      public static function getInstance() : IconVOLoader
      {
         if(!_instance)
         {
            _instance = new IconVOLoader();
         }
         return _instance;
      }
      
      public function setNpcIcon(param1:Sprite, param2:int) : Bitmap
      {
         var _loc3_:InGameCatalog = InGameCatalog.instance;
         var _loc4_:String = _loc3_.getNpcIcon(param2) + "_icon.png";
         var _loc5_:SWFFinisher = ResourceManager.fileCollection.getFinisher("icons") as SWFFinisher;
         var _loc6_:BitmapData = _loc5_.getEmbeddedBitmapData(_loc4_);
         var _loc7_:Bitmap = new Bitmap(_loc6_);
         _loc7_.width = param1.width;
         _loc7_.height = param1.height;
         param1.removeChildren();
         param1.addChild(_loc7_);
         return _loc7_;
      }
      
      public function loadIcon(param1:Sprite, param2:ItemVO, param3:String = null, param4:String = "ITEMS") : IconVO
      {
         var _loc5_:IconVO = this.getIconVO(param2,param1,param3,param4);
         _loc5_.addEventListener(IconVOEvent.EVENT_ICON_LOADED,this.onIconLoaded);
         _loc5_.start();
         return _loc5_;
      }
      
      private function getIconVO(param1:ItemVO, param2:Sprite, param3:String = null, param4:String = "ITEMS") : IconVO
      {
         var _loc5_:IconVO = null;
         if(this.pool.length > 0)
         {
            _loc5_ = this.pool.pop();
            if(_loc5_.status == 0 && _loc5_.reset(param1,param2,param3,param4))
            {
               return _loc5_;
            }
         }
         return new IconVO(param1,param2,param3,param4);
      }
      
      private function onIconLoaded(param1:IconVOEvent) : void
      {
         var _loc2_:IconVO = param1.iconVO;
         _loc2_.removeEventListener(IconVOEvent.EVENT_ICON_LOADED,this.onIconLoaded);
         this.pool.push(_loc2_);
      }
      
      private function unLoadIcon(param1:IconVO) : void
      {
         param1.stop();
         param1.removeEventListener(IconVOEvent.EVENT_ICON_LOADED,this.onIconLoaded);
      }
   }
}

