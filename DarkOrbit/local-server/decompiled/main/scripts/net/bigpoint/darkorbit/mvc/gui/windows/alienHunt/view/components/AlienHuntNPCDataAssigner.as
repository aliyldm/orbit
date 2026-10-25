package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.vo.AlienHuntPointItemVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class AlienHuntNPCDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _name:Label;
      
      private var _points:Label;
      
      private var _bg:Coreponent;
      
      public function AlienHuntNPCDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("npcName",this) as Label;
         this._points = FuiComponentSelectorUtil.selectComponent("points",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:AlienHuntPointItemVO = null;
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            removeLoadResourceCallback("icons",this.handleItemLoaded);
            super.data = param1;
            _loc2_ = this.alienHuntNPCVo;
            if(_loc2_)
            {
               loadResource("icons",this.handleItemLoaded,this.handleItemLoadError);
               this._name.text = InGameCatalog.instance.getNpcName(_loc2_.npcID);
               this._points.text = TextFormatter.roundInteger(_loc2_.points);
            }
         }
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._bg.visible = param1 % 2 == 0;
      }
      
      private function get alienHuntNPCVo() : AlienHuntPointItemVO
      {
         return data as AlienHuntPointItemVO;
      }
      
      private function handleItemLoadError(param1:* = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var key:String = null;
         var finisher:SWFFinisher = param1;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         try
         {
            key = InGameCatalog.instance.getNpcIcon(this.alienHuntNPCVo.npcID) + "_icon.png";
            this._img.addChild(new Bitmap(finisher.getEmbeddedBitmapData(key)));
         }
         catch(e:Error)
         {
            handleItemLoadError();
         }
      }
      
      override public function dispose() : void
      {
         removeLoadResourceCallback("icons",this.handleItemLoaded);
         super.dispose();
      }
   }
}

