#include <unordered_map>
#include <iostream>
#include <vector>
#include <cstring>

class GenTools{
private:
    std::unordered_map<std::string, std::string> sym_table;
    std::unordered_map<std::string, std::string> symlocal_table;
    std::unordered_map<std::string, bool> Arith_vars;

public:
    std::string GlobalVar(const std::string id){
        std::string dataSection = "";
        dataSection = id + " dd " + std::to_string(0) + "\n";
        std::string dword = "dword [" + id + "]";
        sym_table.emplace(id, dword);
        return dataSection;
    }

    std::string LocalVar(const std::string id){
        std::string dataSection = "";
        return dataSection;
    }

    std::string getVar(std::string id){
        std::string value = "";
        if(sym_table.find(id) == sym_table.end()){
            if(symlocal_table.find(id) == symlocal_table.end()){
                value = symlocal_table[id];
            }
            else{
                value = "Crear Nuevo Registro";
            }
        }
        else{
            value = sym_table[id];
        }
        return value;
    }

    void ArithVar(){
        Arith_vars.emplace("eax", false);
        Arith_vars.emplace("ebx", false);
        Arith_vars.emplace("ecx", false);
        Arith_vars.emplace("edx", false);
    }

    std::string GetArithVar(){
        if(Arith_vars["eax"] == false){
            Arith_vars["eax"] = true;
            return "eax";
        }
        else if(Arith_vars["ebx"] == false){
            Arith_vars["ebx"] = true;
            return "ebx";
        }
        else if(Arith_vars["ecx"] == false){
            Arith_vars["ecx"] = true;
            return "ecx";
        }
        else if(Arith_vars["edx"] == false){
            Arith_vars["edx"] = true;
            return "edx";
        }
        else{
            return "All arithmetic registers occupied";
        }
    }

    std::string FreeArithVar(std::string place){
        if(Arith_vars[place] == true){
            Arith_vars[place] = false;
            return place + " has been freed";
        }
        else{
            return place + " already free";
        }
    }
};