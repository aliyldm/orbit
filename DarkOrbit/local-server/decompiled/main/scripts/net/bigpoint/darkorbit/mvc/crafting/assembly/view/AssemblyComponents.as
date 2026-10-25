package net.bigpoint.darkorbit.mvc.crafting.assembly.view
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class AssemblyComponents
   {
      
      private var _view:Container;
      
      public function AssemblyComponents(param1:Container)
      {
         super();
         this._view = param1;
      }
      
      public function get itemListContainer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer",this._view) as Container;
      }
      
      public function get recipesList() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer.recipes",this._view) as ItemList;
      }
      
      public function get firstDivider() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.firstDivider",this._view) as Coreponent;
      }
      
      public function get secondDivider() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.secondDivider",this._view) as Coreponent;
      }
      
      public function get buildContainer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.buildContainer",this._view) as Container;
      }
      
      public function get assemblyWarningContainer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("assembly_warning",this._view) as Container;
      }
      
      public function get detailsContainer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer",this._view) as Container;
      }
      
      public function get recipesLeftButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer.left",this._view) as Button;
      }
      
      public function get recipesRightButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer.right",this._view) as Button;
      }
      
      public function get detailsVid() : VideoPlayer
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.vid",this._view) as VideoPlayer;
      }
      
      public function get detailsText() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.textContainer.assemblyScrollContainerText.content",this._view) as Label;
      }
      
      public function get detailsTextScrollContainer() : ScrollContainer
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.textContainer.assemblyScrollContainerText",this._view) as ScrollContainer;
      }
      
      public function get detailsTextScrollBar() : Scrollbar
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.textContainer.assemblyScrollbarText",this._view) as Scrollbar;
      }
      
      public function get detailsHeadline() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.headline",this._view) as Label;
      }
      
      public function get assemblyWarningLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("assembly_warning.label",this._view) as Label;
      }
      
      public function get detailsTime() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.time",this._view) as Label;
      }
      
      public function get detailsIcon() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.detailsContainer.icon",this._view) as Coreponent;
      }
      
      public function get ingredients() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.buildContainer.ingredients_container",this._view) as ItemList;
      }
   }
}

