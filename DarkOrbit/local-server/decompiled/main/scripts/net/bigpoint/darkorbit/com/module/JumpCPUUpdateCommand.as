package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpCPUUpdateCommand implements IModule
   {
      
      private static var _instance:JumpCPUUpdateCommand;
      
      public var priceList:Vector.<JumpCPUPriceMappingModule>;
      
      public function JumpCPUUpdateCommand(param1:Vector.<JumpCPUPriceMappingModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.priceList = new Vector.<JumpCPUPriceMappingModule>();
         }
         else
         {
            this.priceList = param1;
         }
      }
      
      public static function get instance() : JumpCPUUpdateCommand
      {
         return _instance || (_instance = new JumpCPUUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 65;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:JumpCPUPriceMappingModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.priceList.length > 0)
         {
            this.priceList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = JumpCPUPriceMappingModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.priceList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:JumpCPUPriceMappingModule = null;
         param1.writeShort(65);
         param1.writeByte(this.priceList.length);
         for each(_loc2_ in this.priceList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

