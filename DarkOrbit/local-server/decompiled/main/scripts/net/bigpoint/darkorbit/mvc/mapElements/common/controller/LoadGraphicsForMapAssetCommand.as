package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class LoadGraphicsForMapAssetCommand extends DOAbstractSimpleCommand
   {
      
      public function LoadGraphicsForMapAssetCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:Object = null;
         var _loc5_:FileCollectionFinisher = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Vector.<BitmapData> = null;
         var _loc8_:String = null;
         var _loc9_:BitmapClip = null;
         super.execute(param1);
         var _loc2_:MapAssetLoadVo = param1.getBody() as MapAssetLoadVo;
         var _loc3_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(_loc3_.isLoaded(_loc2_.sourceKey))
         {
            switch(_loc2_.expectedClass)
            {
               case Bitmap:
                  _loc5_ = _loc3_.getLib(_loc2_.sourceKey,_loc2_.instanceId);
                  _loc4_ = (_loc5_ as SWFFinisher).getEmbeddedBitmap(_loc2_.embedKeys[0]) as _loc2_.expectedClass;
                  if(_loc4_ is _loc2_.expectedClass)
                  {
                     _loc2_.callBack(_loc4_ as _loc2_.expectedClass);
                  }
                  else
                  {
                     this.error(_loc2_);
                  }
                  break;
               case MovieClip:
               case Sprite:
               case Shape:
               case DisplayObject:
               case DisplayObjectContainer:
                  _loc5_ = _loc3_.getLib(_loc2_.sourceKey,_loc2_.instanceId);
                  _loc4_ = (_loc5_ as SWFFinisher).getEmbeddedObject(_loc2_.embedKeys[0]);
                  if(_loc4_ is Class)
                  {
                     _loc4_ = new _loc4_();
                  }
                  if(_loc4_ is BitmapData)
                  {
                     _loc4_ = new Bitmap(_loc4_ as BitmapData);
                  }
                  _loc2_.callBack(_loc4_);
                  break;
               case BitmapData:
                  _loc5_ = _loc3_.getLib(_loc2_.sourceKey,_loc2_.instanceId);
                  _loc7_ = new Vector.<BitmapData>();
                  for each(_loc8_ in _loc2_.embedKeys)
                  {
                     _loc6_ = (_loc5_ as SWFFinisher).getEmbeddedBitmapData(_loc8_) as BitmapData;
                     if(_loc6_)
                     {
                        _loc7_.push(_loc6_);
                     }
                  }
                  if(_loc7_.length)
                  {
                     _loc2_.callBack(_loc7_.length == 1 ? _loc7_[0] : _loc7_);
                  }
                  else
                  {
                     this.error(_loc2_);
                  }
                  break;
               case BitmapClip:
                  _loc5_ = _loc3_.getLib(_loc2_.sourceKey,_loc2_.instanceId);
                  _loc4_ = (_loc5_ as SWFFinisher).getEmbeddedObject(_loc2_.embedKeys[0]) as MovieClip;
                  if((Boolean(_loc4_)) && _loc4_ is MovieClip)
                  {
                     _loc9_ = new BitmapClip(_loc4_ as MovieClip,_loc2_.sourceKey + _loc2_.embedKeys[0]);
                     _loc9_.play();
                     _loc2_.callBack(_loc9_);
                  }
                  else
                  {
                     this.error(_loc2_);
                  }
            }
            if(_loc2_.unloadeResources && Settings.unloadResources)
            {
               this.addFinisherToUnloadList(_loc5_);
            }
         }
         else
         {
            sendNotification(MapAssetNotification.RETRY_LOAD,[_loc2_.sourceKey,_loc2_.instanceId,param1]);
         }
      }
      
      private function addFinisherToUnloadList(param1:FileCollectionFinisher) : void
      {
         sendNotification(AssetNotifications.ADD_UNLOAD_FINISHER,param1);
      }
      
      private function error(param1:MapAssetLoadVo) : void
      {
      }
   }
}

