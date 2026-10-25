package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LabRefinementRequest implements IModule
   {
      
      private static var _instance:LabRefinementRequest;
      
      public var toProduce:OreCountModule;
      
      public function LabRefinementRequest(param1:OreCountModule = null)
      {
         super();
         if(param1 == null)
         {
            this.toProduce = new OreCountModule();
         }
         else
         {
            this.toProduce = param1;
         }
      }
      
      public static function get instance() : LabRefinementRequest
      {
         return _instance || (_instance = new LabRefinementRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 132;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.toProduce = OreCountModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toProduce)
         {
            this.toProduce.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(132);
         if(null != this.toProduce)
         {
            this.toProduce.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

