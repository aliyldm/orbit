package net.bigpoint.darkorbit.mvc.gui.windows
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.system.loader.view.ItemLoadingSpinner;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class Loadable extends Sprite
   {
      
      protected var _lootIDs:Array = [];
      
      protected var _loadedIndex:uint = 0;
      
      protected const _loadingSpinner:ItemLoadingSpinner = new ItemLoadingSpinner();
      
      public function Loadable()
      {
         super();
         this._loadingSpinner.start();
         addChild(this._loadingSpinner);
      }
      
      public function load(param1:String) : void
      {
         var _loc2_:ItemVO = null;
         if(param1)
         {
            this._lootIDs.push(param1);
            _loc2_ = ItemDataProviderHelper.getItem(param1);
            if(_loc2_)
            {
               this.loadItemGraphics(_loc2_.getLoot30x30(Hero.factionName),this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
            }
            else
            {
               this.handleItemLoadError(param1);
            }
         }
      }
      
      public function loadItemGraphics(param1:String, param2:Function = null, param3:Function = null, param4:String = "GAME") : void
      {
         UISystem.getInstance().uiloader.load(param1,param2,param3,param4);
      }
      
      protected function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         this._loadingSpinner.finished();
      }
      
      protected function handleItemLoadError(param1:Object = null) : void
      {
         this._loadingSpinner.finished();
      }
   }
}

