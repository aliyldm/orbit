package net.bigpoint.darkorbit.map.hud
{
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.model.traits.LabelTrait;
   
   public class HUDLabel extends AbstractHUDElement
   {
      
      private var _nameLabel:TextField = new TextField();
      
      private var _trait:LabelTrait;
      
      public function HUDLabel(param1:IMapView, param2:LabelTrait)
      {
         super(param1,param2.owner.position);
         this._trait = param2;
         this._trait.text.changed.add(this.updateLabel);
         this._trait.position.changed.add(this.updateLabel);
         var _loc3_:TextFormat = this._trait.tf;
         this._nameLabel.defaultTextFormat = _loc3_;
         this._nameLabel.embedFonts = Styles.nickEmbed;
         this._nameLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._nameLabel.autoSize = TextFieldAutoSize.LEFT;
         this._nameLabel.backgroundColor = this._trait.backgroundColor;
         this._nameLabel.background = this._trait.backgroundColor != 0;
         addChild(this._nameLabel);
         this.updateLabel();
      }
      
      private function updateLabel() : void
      {
         this._nameLabel.text = this._trait.text.value || "";
         this._nameLabel.x = this._trait.x - this._nameLabel.width / 2;
         this._nameLabel.y = this._trait.y - this._nameLabel.height / 2;
      }
   }
}

