package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
   
   public class CommandCenterView
   {
      
      private var _listSection:CommandCenterListSection;
      
      private var _mainSection:CommandCenterMainSection;
      
      private var _dontShowSection:CommandCenterDontShowSection;
      
      private var _container:Sprite;
      
      public function CommandCenterView(param1:Sprite)
      {
         super();
         this._container = param1;
         this._container.visible = false;
         this._listSection = new CommandCenterListSection(param1);
         this._mainSection = new CommandCenterMainSection(param1);
         this._dontShowSection = new CommandCenterDontShowSection(param1);
      }
      
      public function get listSection() : CommandCenterListSection
      {
         return this._listSection;
      }
      
      public function get mainSection() : CommandCenterMainSection
      {
         return this._mainSection;
      }
      
      public function get dontShowSection() : CommandCenterDontShowSection
      {
         return this._dontShowSection;
      }
      
      public function set visible(param1:Boolean) : void
      {
         TweenLite.to(this._container,0.3,{"autoAlpha":(param1 ? 1 : 0)});
      }
      
      public function updateNews(param1:Vector.<CommandCenterCategory>) : void
      {
         this._listSection.updateNews(param1);
         if(param1.length > 0)
         {
            this._mainSection.data = param1[this._listSection.list.selectedIndex];
         }
      }
   }
}

