package net.bigpoint.darkorbit.map.model.minimap.traits
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class MiniMapIconTrait extends AbstractMiniMapTrait
   {
      
      private var _libId:String;
      
      private var _resKey:String;
      
      private var _scaleMultiplier:Number = 0;
      
      public function MiniMapIconTrait(param1:String, param2:String = "minimap", param3:int = 0, param4:Number = 0)
      {
         this._resKey = param1;
         this._libId = param2;
         this._scaleMultiplier = param4 || 0;
         super(new Bitmap(),true,true,param3);
      }
      
      public function set resKey(param1:String) : void
      {
         this._resKey = param1;
         this.load();
      }
      
      private function load() : void
      {
         if(owner)
         {
            ResourceManager.fileCollection.load(this._libId,this.handleResourcesLoadComplete);
         }
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         this.load();
      }
      
      override public function deactivateTrait() : void
      {
         ResourceManager.fileCollection.removeCallbacks(this._libId,this.handleResourcesLoadComplete);
         super.deactivateTrait();
      }
      
      private function handleResourcesLoadComplete(param1:SWFFinisher) : void
      {
         Bitmap(_icon).bitmapData = param1.hasEmbeddedObject(this._resKey) ? param1.getEmbeddedBitmapData(this._resKey) : null;
         this.update();
      }
      
      override protected function update() : void
      {
         if(this._scaleMultiplier != 0)
         {
            _icon.scaleX = _icon.scaleY = this._scaleMultiplier * _scale;
         }
         super.update();
      }
   }
}

