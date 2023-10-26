'''
    File name: log2file.py
    Author: Benoit Denkinger
    Date created: 15/06/2018
    Python Version: Python 3.4.3
    Description: class to easily create a nice log file
'''

'''
Example

myLog = log2file('log2file_example', 5, 2, 3, len('OUTPUT'), 10)
myLog.log_column_name('Index', 34, 'TP', 'OUTPUT', 'DATE/TIME')
myLog.log_line('4', 65, '001', '67', 2323456456)
myLog.log_line('4', '23', 1, '67', 56456)
'''

class log2file(object):

	def __init__(self, filename, *args):
		"""
	    Init the log file and set the number of entries/columns per line.

	    Parameters
	    ----------
	    filename : str
	    args     : list of int; max character length for each column

	    Returns
	    -------
	    None
	    """

		self.filename = filename
		self.num_entry = len(args)
		self.entry_max_length = []
		# self.tab_length = tab_length
		self.space_char = ' '
		self.space_length = 4
		self.entry_spacing = []

		self.outputFile = open(filename, 'w')
		assert(self.outputFile)

		for idx in range(len(args)):

			val = args[idx]
			self.entry_max_length.append(val)
			self.entry_spacing.append(self.space_char * self.space_length)


	def log_column_name(self, *args):
		"""
	    Log a new line with the name of the columns followed by a dash line.

	    Parameters
	    ----------
	    args     : list of string (name of each column)

	    Returns
	    -------
	    None
	    """
		assert(len(args) == self.num_entry)

		self.outputFile = open(self.filename, 'a')
		assert(self.outputFile)

		for idx in range(len(args)):

			col_name = args[idx]

			if isinstance(col_name, str):
				if len(col_name) > self.entry_max_length[idx]:
					self.entry_max_length[idx] = len(col_name)

				self.outputFile.write(col_name)
			else:
				col_name = str(col_name)
				if len(col_name) > self.entry_max_length[idx]:
					self.entry_max_length[idx] = len(col_name)

				self.outputFile.write(col_name)

			if idx < self.num_entry-1:
				correction = self.entry_max_length[idx] - len(col_name)
				self.outputFile.write(self.entry_spacing[idx] + self.space_char * correction)

		# write separation between title and entries
		entry_tot_len = 0
		for val in self.entry_max_length:
			entry_tot_len = entry_tot_len + val
		assert(entry_tot_len)

		line_length = entry_tot_len + (self.num_entry-1) * self.space_length
		self.outputFile.write('\n' + '-' * line_length + '\n')

		self.outputFile.close()


	def log_line(self, *args):
		"""
	    Log a new line of data. It expects one entry per column.

	    Parameters
	    ----------
	    args     : list of string or/and int;

	    Returns
	    -------
	    None
	    """
		assert(len(args) == self.num_entry)

		self.outputFile = open(self.filename, 'a')
		assert(self.outputFile)

		for idx in range(len(args)):

			entry = args[idx]

			if isinstance(entry, str):
				assert(len(entry) <= self.entry_max_length[idx])
				self.outputFile.write(entry)
			else:
				entry = str(entry)
				assert(len(entry) <= self.entry_max_length[idx])
				self.outputFile.write(entry)

			if idx < self.num_entry-1:
				correction = self.entry_max_length[idx] - len(entry)
				self.outputFile.write(self.entry_spacing[idx] + self.space_char * correction)

		self.outputFile.write('\n')
		self.outputFile.close()


	def log_empty_line(self, num_lines=1):
		"""
	    Create num_lines number of empty line(s).

	    Parameters
	    ----------
	    num_lines : int

	    Returns
	    -------
	    None
	    """

		self.outputFile = open(self.filename, 'a')
		assert(self.outputFile)

		self.outputFile.write('\n' * num_lines)
		self.outputFile.close()


##############################################################################################
# Example

# myLog = log2file('log2file_example', 5, 2, 3, len('OUTPUT'), 10)
# myLog.log_column_name('Index', 34, 'TP', 'OUTPUT', 'DATE/TIME')
# myLog.log_line('4', 65, '001', '67', 2323456456)
# myLog.log_line('4', '23', 1, '67', 56456)