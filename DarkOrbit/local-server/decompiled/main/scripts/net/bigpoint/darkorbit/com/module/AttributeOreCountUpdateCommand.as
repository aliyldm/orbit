package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeOreCountUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeOreCountUpdateCommand;
      
      public var oreCountList:Vector.<OreCountModule>;
      
      public function AttributeOreCountUpdateCommand(param1:Vector.<OreCountModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.oreCountList = new Vector.<OreCountModule>();
         }
         else
         {
            this.oreCountList = param1;
         }
      }
      
      public static function get instance() : AttributeOreCountUpdateCommand
      {
         return _instance || (_instance = new AttributeOreCountUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 106;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:OreCountModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.oreCountList.length > 0)
         {
            this.oreCountList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = OreCountModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.oreCountList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:OreCountModule = null;
         param1.writeShort(106);
         param1.writeByte(this.oreCountList.length);
         for each(_loc2_ in this.oreCountList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

