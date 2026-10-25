package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class OrePriceModule implements IModule
   {
      
      private static var _instance:OrePriceModule;
      
      public var oreType:OreTypeModule;
      
      public var price:int = 0;
      
      public function OrePriceModule(param1:OreTypeModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.oreType = new OreTypeModule();
         }
         else
         {
            this.oreType = param1;
         }
         this.price = param2;
      }
      
      public static function get instance() : OrePriceModule
      {
         return _instance || (_instance = new OrePriceModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 129;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.oreType = OreTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.oreType)
         {
            this.oreType.read(param1);
         }
         this.price = param1.readInt();
         this.price = this.price << 2 % 32 | this.price >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(129);
         if(null != this.oreType)
         {
            this.oreType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.price >>> 2 % 32 | this.price << 32 - 2 % 32);
      }
   }
}

