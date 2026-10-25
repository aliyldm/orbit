package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TechStatusCommand implements IModule
   {
      
      private static var _instance:TechStatusCommand;
      
      public var techStatusItems:Vector.<TechStatusItemModule>;
      
      public function TechStatusCommand(param1:Vector.<TechStatusItemModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.techStatusItems = new Vector.<TechStatusItemModule>();
         }
         else
         {
            this.techStatusItems = param1;
         }
      }
      
      public static function get instance() : TechStatusCommand
      {
         return _instance || (_instance = new TechStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 72;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TechStatusItemModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.techStatusItems.length > 0)
         {
            this.techStatusItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TechStatusItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.techStatusItems.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TechStatusItemModule = null;
         param1.writeShort(72);
         param1.writeByte(this.techStatusItems.length);
         for each(_loc2_ in this.techStatusItems)
         {
            _loc2_.write(param1);
         }
      }
   }
}

