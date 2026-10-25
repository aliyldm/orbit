package away3d.materials
{
   public class ColorMultiPassMaterial extends MultiPassMaterialBase
   {
      
      public function ColorMultiPassMaterial(param1:uint = 13421772)
      {
         super();
         this.color = param1;
      }
      
      public function get color() : uint
      {
         return diffuseMethod.diffuseColor;
      }
      
      public function set color(param1:uint) : void
      {
         diffuseMethod.diffuseColor = param1;
      }
   }
}

