package net.bigpoint.darkorbit.fui.components.core.skins
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public class BasicStateSkin extends BasicSkin
   {
      
      private var _skinLayerDefintions:Dictionary = new Dictionary();
      
      public function BasicStateSkin()
      {
         super();
      }
      
      override public function init() : void
      {
         var _loc1_:String = null;
         if(!_initialized)
         {
            for(_loc1_ in _layers)
            {
               _resizablelayers.push(_loc1_);
            }
            this.mouseEnabled = false;
            this.mouseChildren = false;
            if(_layers[SkinLayerNames.MASK])
            {
               _mask = _layers[SkinLayerNames.MASK];
               _mask.cacheAsBitmap = true;
            }
            this.setCurrentSkinState(getCurrentState());
         }
      }
      
      override public function getSkinLayerDefintions() : Dictionary
      {
         return this._skinLayerDefintions;
      }
      
      override protected function setCurrentSkinState(param1:String) : void
      {
         if(param1 != getCurrentState())
         {
            hideState(getCurrentState());
            super.setCurrentSkinState(param1);
            showState(param1);
         }
      }
      
      override public function setSkinLayer(param1:String, param2:DisplayObject) : void
      {
         super.setSkinLayer(param1,param2);
         param2.visible = false;
         addChild(param2);
      }
      
      override public function clone() : ISkin
      {
         return super.clone();
      }
   }
}

