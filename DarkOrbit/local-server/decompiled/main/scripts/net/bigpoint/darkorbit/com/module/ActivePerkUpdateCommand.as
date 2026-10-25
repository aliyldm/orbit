package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ActivePerkUpdateCommand implements IModule
   {
      
      private static var _instance:ActivePerkUpdateCommand;
      
      public var activePerkModuleList:Vector.<ActivePerkModule>;
      
      public function ActivePerkUpdateCommand(param1:Vector.<ActivePerkModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.activePerkModuleList = new Vector.<ActivePerkModule>();
         }
         else
         {
            this.activePerkModuleList = param1;
         }
      }
      
      public static function get instance() : ActivePerkUpdateCommand
      {
         return _instance || (_instance = new ActivePerkUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20339;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ActivePerkModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.activePerkModuleList.length > 0)
         {
            this.activePerkModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ActivePerkModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.activePerkModuleList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ActivePerkModule = null;
         param1.writeShort(-20339);
         param1.writeByte(this.activePerkModuleList.length);
         for each(_loc2_ in this.activePerkModuleList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

