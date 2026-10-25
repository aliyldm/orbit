package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanApplyInfoListCommand implements IModule
   {
      
      private static var _instance:ClanApplyInfoListCommand;
      
      public var applyClanInfoCommandList:Vector.<ClanApplyInfoCommand>;
      
      public function ClanApplyInfoListCommand(param1:Vector.<ClanApplyInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.applyClanInfoCommandList = new Vector.<ClanApplyInfoCommand>();
         }
         else
         {
            this.applyClanInfoCommandList = param1;
         }
      }
      
      public static function get instance() : ClanApplyInfoListCommand
      {
         return _instance || (_instance = new ClanApplyInfoListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4845;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanApplyInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.applyClanInfoCommandList.length > 0)
         {
            this.applyClanInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanApplyInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.applyClanInfoCommandList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanApplyInfoCommand = null;
         param1.writeShort(4845);
         param1.writeShort(this.applyClanInfoCommandList.length);
         for each(_loc2_ in this.applyClanInfoCommandList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

