#this script outputs data for each molecule in a given BNX
import re

class Cohort:
    def __init__(self, scan, bank, cohort):
        self.scan = scan
        self.bank = bank
        self.cohort = int(cohort)

def analyze_run_data(run_data_line):
    run_info = run_data_line.strip().split("\t")
    run_id = run_info[-1]
    cohort_info = re.search(r'Cohort(\d{2})(\d)(\d)', run_info[1])
    return (run_id, Cohort(cohort_info.group(1), cohort_info.group(2), cohort_info.group(3)))

def analyze_bnx_file(bnx_input_path, summary_output_path):
    with open(summary_output_path, 'w') as output_file:
        header = "\t".join(["molecule_id", "scan", "bank", "cohort", "column", "column from line", "length", "num_labels_c1", "num_labels_c2","yoyo_avg_intensity"]) + "\n"
        output_file.write(header)
        with open(bnx_input_path) as bnx_file:
            run_data = {}
            line1 = bnx_file.readline()
            while not line1.startswith("# Run Data"):
                line1 = bnx_file.readline()
            while line1.startswith("# Run Data"):
                run_id, cohort = analyze_run_data(line1)
                run_data[run_id] = cohort
                line1 = bnx_file.readline()
            while line1.startswith("#"):
                line1 = bnx_file.readline()
            while line1:
                line2 = bnx_file.readline() #channel 1 positions
                line3 = bnx_file.readline() #channel 2 positions
                line4 = bnx_file.readline() #QX11
                line5 = bnx_file.readline() #QX21
                line6 = bnx_file.readline() #QX12
                line7 = bnx_file.readline() #QX22

                mol_info = line1.split()
                mol_id = mol_info[1]
                mol_length = mol_info[2]
                mol_run_id = mol_info[11]
                mol_column1 = int(mol_info[12])
                mol_column = str((run_data[mol_run_id].cohort - 1) * 34 + mol_column1)
                num_channel1_labels = len(line2.split()[1:-1])
                num_channel2_labels = len(line3.split()[1:-1])
                yoyo_avg_intensity=mol_info[3]

                mol_line = "\t".join([mol_id, run_data[mol_run_id].scan, run_data[mol_run_id].bank, str(run_data[mol_run_id].cohort),
                                      mol_column, str(mol_column1), mol_length, str(num_channel1_labels), str(num_channel2_labels), yoyo_avg_intensity]) + "\n"
                output_file.write(mol_line)

                line1 = bnx_file.readline()


input_bnx_file = r'D:\Sapir\PhD\GM12878 analysis\alex sample our saphyr\Merged_data_set_Swapped_Channels_swapped_RawMolecules.bnx'

output_file_path = r'D:\Sapir\PhD\GM12878 analysis\alex sample our saphyr\Merged_data_set_Swapped_Channels_swapped_RawMolecules_bnx_summary.txt'

print("reading bnx")
analyze_bnx_file(input_bnx_file, output_file_path)
print("complete")
                
                
