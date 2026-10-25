package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class OreCountModule implements IModule
   {
      
      private static var _instance:OreCountModule;
      
      public var oreType:OreTypeModule;
      
      public var count:Number = 0;
      
      public function OreCountModule(param1:OreTypeModule = null, param2:Number = 0)
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
         this.count = param2;
      }
      
      public static function get instance() : OreCountModule
      {
         return _instance || (_instance = new OreCountModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 105;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.oreType = OreTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.oreType)
         {
            this.oreType.read(param1);
         }
         this.count = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(105);
         if(null != this.oreType)
         {
            this.oreType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.count);
      }
   }
}

