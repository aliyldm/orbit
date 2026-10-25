package net.bigpoint.darkorbit.mvc.galaxygatebuilder.utils
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ItemImageLoader
   {
      
      public const loaded:ISignal = new Signal(int,String);
      
      private var _gateID:int;
      
      private var _lootVO:ItemVO;
      
      private var _bitmap:Bitmap;
      
      public function ItemImageLoader(param1:int, param2:String)
      {
         super();
         this._gateID = param1;
         this._lootVO = ItemDataProviderHelper.getItem(param2);
         this._bitmap = new Bitmap();
      }
      
      public function get bitmap() : Bitmap
      {
         return this._bitmap;
      }
      
      public function load() : void
      {
         var _loc3_:FileCollection = null;
         var _loc4_:ImageFinisher = null;
         if(this._lootVO == null)
         {
            return;
         }
         var _loc1_:String = this._lootVO.getLoot100x100();
         var _loc2_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(!_loc2_.isLoaded(_loc1_,AssetsProxy.ITEMS))
         {
            _loc2_.load(_loc1_,this.handleImageLoaded,this.handleImageLoadError,AssetsProxy.ITEMS);
         }
         else
         {
            _loc3_ = _loc2_.getFileCollectionByInstanceName(AssetsProxy.ITEMS);
            _loc4_ = _loc3_.getFinisher(_loc1_) as ImageFinisher;
            this.handleImageLoaded(_loc4_);
         }
      }
      
      private function handleImageLoaded(param1:ImageFinisher = null) : void
      {
         this._bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this.loaded.dispatch(this._gateID,this._lootVO.lootID);
      }
      
      private function handleImageLoadError(param1:*) : void
      {
      }
   }
}

