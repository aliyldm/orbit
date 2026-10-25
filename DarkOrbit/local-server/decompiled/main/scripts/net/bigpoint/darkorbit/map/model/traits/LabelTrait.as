package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class LabelTrait extends EntityTraitBase
   {
      
      private const TEXTFORMAT:TextFormat = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,16777215,Styles.nickFmt.bold);
      
      public const text:BindableString = new BindableString();
      
      public const position:BindablePointLite = new BindablePointLite(0,0);
      
      private var _tf:TextFormat;
      
      private var _backgroundColor:uint;
      
      public function LabelTrait(param1:String = null, param2:int = 0, param3:int = 0, param4:TextFormat = null, param5:uint = 0)
      {
         super();
         this._backgroundColor = param5;
         this._tf = param4 || this.TEXTFORMAT;
         this.text.value = param1;
         this.position.x = param2;
         this.position.y = param3;
      }
      
      public function get tf() : TextFormat
      {
         return this._tf;
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function get x() : int
      {
         return this.position.x;
      }
      
      public function get y() : int
      {
         return this.position.y;
      }
      
      public function set x(param1:int) : void
      {
         this.position.x = param1;
      }
      
      public function set y(param1:int) : void
      {
         this.position.y = param1;
      }
   }
}

