package net.bigpoint.darkorbit.mvc.display.utils
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.vo.AtlasResourceVO;
   import org.osflash.signals.Promise;
   
   public class DOTexturesProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "DOTexturesProxy";
      
      private var _resourcesByAtlasAndTexture:Dictionary = new Dictionary();
      
      public function DOTexturesProxy()
      {
         super(NAME);
      }
      
      public function getTextureResource(param1:String, param2:String, param3:String = "texture") : DOBitmapAtlasResource
      {
         var _loc4_:String = param2 + param1;
         var _loc5_:DOBitmapAtlasResource = this._resourcesByAtlasAndTexture[_loc4_];
         if(_loc5_ == null)
         {
            _loc5_ = new DOBitmapAtlasResource(param3);
            this._resourcesByAtlasAndTexture[_loc4_] = _loc5_;
            this.load(_loc5_,param1,param2);
         }
         return _loc5_;
      }
      
      public function getTextureResourceWithPrefix(param1:String, param2:String = "texture") : DOBitmapAtlasResource
      {
         return this.getTextureResource(param1 + "_texture",param1 + "_atlas",param2);
      }
      
      public function clean() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._resourcesByAtlasAndTexture)
         {
            DOBitmapAtlasResource(this._resourcesByAtlasAndTexture[_loc1_]).dispose();
            this._resourcesByAtlasAndTexture[_loc1_] = null;
            delete this._resourcesByAtlasAndTexture[_loc1_];
         }
      }
      
      private function load(param1:DOBitmapAtlasResource, param2:String, param3:String) : void
      {
         var resource:DOBitmapAtlasResource = param1;
         var textureResKey:String = param2;
         var atlasResKey:String = param3;
         ResourceManager.fileCollection.load(textureResKey,function(param1:FileCollectionFinisher):void
         {
            if(param1 is ImageFinisher)
            {
               resource.setTexture(ImageFinisher(param1).getBitmap().bitmapData);
            }
            else if(param1 is SWFFinisher)
            {
               resource.setTexture(SWFFinisher(param1).getEmbeddedBitmapData(resource.embeddedTextureClassName));
            }
            else if(param1 is DefaultFinisher)
            {
               resource.setTexture(DefaultFinisher(param1).data);
            }
            sendNotification(AssetNotifications.ADD_UNLOAD_FINISHER,param1);
         });
         ResourceManager.fileCollection.load(atlasResKey,function(param1:XMLFinisher):void
         {
            resource.setAtlas(new DOAtlas(param1.getXML()));
            sendNotification(AssetNotifications.ADD_UNLOAD_FINISHER,param1);
         });
      }
      
      public function getTextureResources(param1:Vector.<AtlasResourceVO>) : Promise
      {
         var _loc4_:AtlasResourceVO = null;
         var _loc2_:MacroLoadPromise = new MacroLoadPromise(param1.length);
         var _loc3_:uint = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_];
            this.getTextureResource(_loc4_.textureResource,_loc4_.atlasResources).ready.addOnce(_loc2_.atlasLoaded);
            _loc5_++;
         }
         return _loc2_.ready;
      }
   }
}

import org.osflash.signals.Promise;

class MacroLoadPromise
{
   
   private var _ready:Promise = new Promise();
   
   private var _callCounts:uint;
   
   private var _callCountsTotal:uint;
   
   public function MacroLoadPromise(param1:uint)
   {
      super();
      this._callCountsTotal = param1;
   }
   
   public function get ready() : Promise
   {
      return this._ready;
   }
   
   private function notify() : void
   {
      this._ready.dispatch();
   }
   
   public function atlasLoaded() : void
   {
      ++this._callCounts;
      this.check();
   }
   
   private function check() : void
   {
      if(this._callCounts == this._callCountsTotal)
      {
         this.notify();
      }
   }
}
